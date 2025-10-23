module pe (
    input  wire        clk,
    input  wire        rst,    // synchronous active-high reset
    input  wire [31:0] a,
    input  wire [31:0] b,
    output wire [31:0] c
);

    // Compute the 64-bit product combinationally
    wire [63:0] product = a * b;

    // 64-bit accumulator register
    reg [63:0] acc;

    // Sequential logic: synchronous reset and accumulate
    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'd0;
        end else begin
            acc <= acc + product;
        end
    end

    // Output lower 32 bits of the accumulator
    assign c = acc[31:0];

endmodule