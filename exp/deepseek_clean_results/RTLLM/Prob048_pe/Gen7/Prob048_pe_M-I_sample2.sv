module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline register
    reg signed [31:0] product_reg;
    
    // Multiplier stage
    wire signed [31:0] product = a * b;
    
    // Accumulator stage
    wire signed [31:0] accum_in = rst ? 32'd0 : product_reg;
    wire signed [31:0] next_c = c + accum_in;
    
    always @(posedge clk) begin
        // Pipeline register update
        product_reg <= product;
        
        // Accumulator update
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= next_c;
        end
    end

endmodule