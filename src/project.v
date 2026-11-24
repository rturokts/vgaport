module tt_um_vga_example (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    wire hsync;
    wire vsync;
    wire video_active;
    wire [9:0] pix_x;
    wire [9:0] pix_y;

    hvsync_generator vga_sync_gen (
        .clk        (clk),
        .reset      (!rst_n),
        .hsync      (hsync),
        .vsync      (vsync),
        .display_on (video_active),
        .hpos       (pix_x),
        .vpos       (pix_y)
    );

    // ============================================================
    // TEXTO: 3 lineas de 16 caracteres cada una.
    //
    // Cada caracter usa una fuente de 16x16.
    // Cada pixel de la fuente se muestra como un bloque 2x2.
    //
    // 1 caracter = 32x32 pixeles VGA
    // 16 caracteres = 512 pixeles de ancho
    // 3 lineas = 96 pixeles de alto
    //
    // Cada NAME tiene 128 bits = 16 caracteres x 8 bits.
    // ============================================================

    localparam [127:0] NAME1 = "ARTURO #        ";
    localparam [127:0] NAME2 = "TINY TAPEOUT    ";
    localparam [127:0] NAME3 = "LINEA 3         ";

    localparam [9:0] TEXT_X      = 64;
    localparam [9:0] TEXT_Y      = 144;
    localparam [9:0] TEXT_WIDTH  = 512;
    localparam [9:0] TEXT_HEIGHT = 96;

    // ------------------------------------------------------------
    // Area total de las tres lineas
    // ------------------------------------------------------------
    wire inside_text;

    assign inside_text =
        (pix_x >= TEXT_X) &&
        (pix_x < TEXT_X + TEXT_WIDTH) &&
        (pix_y >= TEXT_Y) &&
        (pix_y < TEXT_Y + TEXT_HEIGHT);

    // Coordenadas relativas al bloque de texto
    wire [9:0] text_x;
    wire [9:0] text_y;

    assign text_x = pix_x - TEXT_X;
    assign text_y = pix_y - TEXT_Y;

    // ------------------------------------------------------------
    // Seleccion de linea
    //
    // text_y[6:5]:
    // 00 -> primera linea
    // 01 -> segunda linea
    // 10 -> tercera linea
    // ------------------------------------------------------------
    wire [1:0] line_index;
    assign line_index = text_y[6:5];

    // ------------------------------------------------------------
    // Seleccion de caracter
    //
    // Cada caracter ocupa 32 pixeles.
    // 16 caracteres -> indice de 4 bits.
    // ------------------------------------------------------------
    wire [3:0] char_index;
    assign char_index = text_x[8:5];

    // ------------------------------------------------------------
    // Coordenadas dentro de la fuente 16x16
    //
    // Cada pixel de la fuente se duplica 2x2:
    // text_x[4:1] -> columna 0..15
    // text_y[4:1] -> fila 0..15
    // ------------------------------------------------------------
    wire [3:0] font_x;
    wire [3:0] font_y;

    assign font_x = text_x[4:1];
    assign font_y = text_y[4:1];

    // ------------------------------------------------------------
    // Codigo ASCII del caracter actual
    // ------------------------------------------------------------
    reg [7:0] char_code;

    always @(*) begin
        case (line_index)

            // ====================================================
            // Primera linea
            // ====================================================
            2'b00: begin
                case (char_index)
                    4'd0:  char_code = NAME1[127:120];
                    4'd1:  char_code = NAME1[119:112];
                    4'd2:  char_code = NAME1[111:104];
                    4'd3:  char_code = NAME1[103:96];
                    4'd4:  char_code = NAME1[95:88];
                    4'd5:  char_code = NAME1[87:80];
                    4'd6:  char_code = NAME1[79:72];
                    4'd7:  char_code = NAME1[71:64];
                    4'd8:  char_code = NAME1[63:56];
                    4'd9:  char_code = NAME1[55:48];
                    4'd10: char_code = NAME1[47:40];
                    4'd11: char_code = NAME1[39:32];
                    4'd12: char_code = NAME1[31:24];
                    4'd13: char_code = NAME1[23:16];
                    4'd14: char_code = NAME1[15:8];
                    4'd15: char_code = NAME1[7:0];
                    default: char_code = 8'h20;
                endcase
            end

            // ====================================================
            // Segunda linea
            // ====================================================
            2'b01: begin
                case (char_index)
                    4'd0:  char_code = NAME2[127:120];
                    4'd1:  char_code = NAME2[119:112];
                    4'd2:  char_code = NAME2[111:104];
                    4'd3:  char_code = NAME2[103:96];
                    4'd4:  char_code = NAME2[95:88];
                    4'd5:  char_code = NAME2[87:80];
                    4'd6:  char_code = NAME2[79:72];
                    4'd7:  char_code = NAME2[71:64];
                    4'd8:  char_code = NAME2[63:56];
                    4'd9:  char_code = NAME2[55:48];
                    4'd10: char_code = NAME2[47:40];
                    4'd11: char_code = NAME2[39:32];
                    4'd12: char_code = NAME2[31:24];
                    4'd13: char_code = NAME2[23:16];
                    4'd14: char_code = NAME2[15:8];
                    4'd15: char_code = NAME2[7:0];
                    default: char_code = 8'h20;
                endcase
            end

            // ====================================================
            // Tercera linea
            // ====================================================
            2'b10: begin
                case (char_index)
                    4'd0:  char_code = NAME3[127:120];
                    4'd1:  char_code = NAME3[119:112];
                    4'd2:  char_code = NAME3[111:104];
                    4'd3:  char_code = NAME3[103:96];
                    4'd4:  char_code = NAME3[95:88];
                    4'd5:  char_code = NAME3[87:80];
                    4'd6:  char_code = NAME3[79:72];
                    4'd7:  char_code = NAME3[71:64];
                    4'd8:  char_code = NAME3[63:56];
                    4'd9:  char_code = NAME3[55:48];
                    4'd10: char_code = NAME3[47:40];
                    4'd11: char_code = NAME3[39:32];
                    4'd12: char_code = NAME3[31:24];
                    4'd13: char_code = NAME3[23:16];
                    4'd14: char_code = NAME3[15:8];
                    4'd15: char_code = NAME3[7:0];
                    default: char_code = 8'h20;
                endcase
            end

            // ----------------------------------------------------
            // Fuera de las tres lineas
            // ----------------------------------------------------
            default: char_code = 8'h20;

        endcase
    end

    // ------------------------------------------------------------
    // ROM de fuente 16x16
    // ------------------------------------------------------------
    wire [15:0] glyph;

    font_rom font (
        .char_code (char_code),
        .row       (font_y),
        .pixels    (glyph)
    );

    // pixels[15] = pixel izquierdo
    wire font_pixel;
    assign font_pixel = glyph[15 - font_x];

    // ------------------------------------------------------------
    // Colores
    // ------------------------------------------------------------
    reg [1:0] R;
    reg [1:0] G;
    reg [1:0] B;

    reg [1:0] bg_R;
    reg [1:0] bg_G;
    reg [1:0] bg_B;

    always @(*) begin

        // Color de fondo seleccionado por ui_in[3:2]
        case (ui_in[3:2])
            2'b00: begin
                bg_R = 2'b00;
                bg_G = 2'b00;
                bg_B = 2'b00;
            end

            2'b01: begin
                bg_R = 2'b11;
                bg_G = 2'b00;
                bg_B = 2'b00;
            end

            2'b10: begin
                bg_R = 2'b00;
                bg_G = 2'b11;
                bg_B = 2'b00;
            end

            2'b11: begin
                bg_R = 2'b00;
                bg_G = 2'b00;
                bg_B = 2'b11;
            end
        endcase

        R = bg_R;
        G = bg_G;
        B = bg_B;

        // Color del texto seleccionado por ui_in[1:0]
        if (video_active && inside_text && font_pixel) begin

            case (ui_in[1:0])
                2'b00: begin
                    R = 2'b11;
                    G = 2'b11;
                    B = 2'b11;
                end

                2'b01: begin
                    R = 2'b11;
                    G = 2'b00;
                    B = 2'b00;
                end

                2'b10: begin
                    R = 2'b00;
                    G = 2'b11;
                    B = 2'b00;
                end

                2'b11: begin
                    R = 2'b00;
                    G = 2'b00;
                    B = 2'b11;
                end
            endcase

        end
    end

    // ------------------------------------------------------------
    // Salida VGA
    // ------------------------------------------------------------
    assign uo_out = {
        hsync,
        B[0],
        G[0],
        R[0],
        vsync,
        B[1],
        G[1],
        R[1]
    };

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule

