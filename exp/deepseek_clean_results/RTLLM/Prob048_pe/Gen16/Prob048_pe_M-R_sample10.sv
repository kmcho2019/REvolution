module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal signals
    wire signed [31:0] product;
    wire signed [31:0] accum_in;

    // Combinational logic
    assign product = a * b;          // 32x32->32 multiplication
    assign accum_in = c + product;   // Accumulation path

    // Sequential logic
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= accum_in;
        end
    end

endmodule