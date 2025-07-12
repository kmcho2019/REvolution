module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

    // Extended versions of inputs (zero-padded)
    wire [7:0] ext_a = {4'b0, mul_a};
    wire [7:0] ext_b = {4'b0, mul_b};

    // Partial products
    wire [7:0] pp0 = ext_b[0] ? ext_a       : 8'b0;
    wire [7:0] pp1 = ext_b[1] ? ext_a << 1  : 8'b0;
    wire [7:0] pp2 = ext_b[2] ? ext_a << 2  : 8'b0;
    wire [7:0] pp3 = ext_b[3] ? ext_a << 3  : 8'b0;

    // Sum of all partial products
    wire [7:0] product = pp0 + pp1 + pp2 + pp3;

    // Output register with reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 8'b0;
        end else begin
            mul_out <= product;
        end
    end

endmodule