module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire clk_enable = shift_ena | count_ena;
wire clk_gated = clk & clk_enable;

always @(posedge clk_gated) begin
    if (shift_ena)
        q <= {q[2:0], data};  // Shift operation
    else // count_ena must be true if we're here
        q <= q - 1'b1;        // Count operation
end

endmodule