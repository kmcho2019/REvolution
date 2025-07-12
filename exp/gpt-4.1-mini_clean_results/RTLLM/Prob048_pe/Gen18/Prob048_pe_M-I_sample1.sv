module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg  [63:0] acc;
    wire [63:0] product;

    // Combinational product calculation (32x32 multiplication)
    assign product = a * b;

    // Sequential accumulation with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'd0;
        end else begin
            acc <= acc + product;
        end
    end

    // Output lower 32 bits of accumulator
    assign c = acc[31:0];

endmodule