module pe (
    input wire clk,
    input wire rst,
    input wire en,          // Enable signal
    input wire [1:0] prec,  // Precision control: 00=8b, 01=16b, 10=24b, 11=32b
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [63:0] product_reg;
    reg [1:0] prec_reg;
    
    // Precision masks
    wire [31:0] prec_mask = (prec == 2'b00) ? 32'h000000FF :
                           (prec == 2'b01) ? 32'h0000FFFF :
                           (prec == 2'b10) ? 32'h00FFFFFF : 32'hFFFFFFFF;
    
    // Clock gating
    wire gated_clk;
    assign gated_clk = clk & en;

    // Stage 1: Input registration and multiplication
    always @(posedge gated_clk or posedge rst) begin
        if (rst) begin
            a_reg <= 32'sd0;
            b_reg <= 32'sd0;
            prec_reg <= 2'b11;
            product_reg <= 64'sd0;
        end else begin
            a_reg <= a & prec_mask;
            b_reg <= b & prec_mask;
            prec_reg <= prec;
            product_reg <= (a & prec_mask) * (b & prec_mask);
        end
    end

    // Stage 2: Accumulation with saturation
    always @(posedge gated_clk or posedge rst) begin
        if (rst) begin
            c <= 32'sd0;
        end else begin
            // Saturation arithmetic for overflow protection
            if ((product_reg[63:32] != 0) && (product_reg[63:32] != {32{product_reg[31]}})) begin
                c <= product_reg[63] ? 32'h80000000 : 32'h7FFFFFFF;
            end else begin
                c <= c + product_reg[31:0];
            end
        end
    end

endmodule