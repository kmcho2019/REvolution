module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire enable_bit1 = q[0];
wire enable_bit2 = q[0] & q[1];
wire enable_bit3 = q[0] & q[1] & q[2];

reg [3:0] next_q;

always @(*) begin
    // Bit 0 always toggles
    next_q[0] = ~q[0];
    // Higher bits toggle only when their enable signals are active
    next_q[1] = enable_bit1 ? ~q[1] : q[1];
    next_q[2] = enable_bit2 ? ~q[2] : q[2];
    next_q[3] = enable_bit3 ? ~q[3] : q[3];
end

always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else
        q <= next_q;
end

endmodule