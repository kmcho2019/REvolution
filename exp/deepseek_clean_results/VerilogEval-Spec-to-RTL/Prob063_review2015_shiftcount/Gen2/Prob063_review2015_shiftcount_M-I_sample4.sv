module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire clk_enable = shift_ena | count_ena;
wire gated_clk = clk & clk_enable;

always @(posedge gated_clk) begin
    if (shift_ena) begin
        // Shift operation (MSB first)
        q <= {q[2:0], data};
    end
    else if (count_ena) begin
        // Ripple-borrow decrement (better timing than subtraction)
        q[0] <= ~q[0];
        q[1] <= q[1] ^ (~q[0]);
        q[2] <= q[2] ^ (&q[1:0]);
        q[3] <= q[3] ^ (&q[2:0]);
    end
    // If neither is enabled, clock is gated and q retains its value
end

endmodule