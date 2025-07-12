module pe (
    input           clk,
    input           rst,    // asynchronous active-high reset
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg [63:0] acc;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            acc <= 64'd0;
        end else begin
            acc <= acc + (a * b);
        end
    end

    // Output the lower 32 bits of the accumulator
    assign c = acc[31:0];

endmodule