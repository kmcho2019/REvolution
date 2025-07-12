module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Next state logic: derive next_state from a, b, and current state
assign next_state = (state & ~(a & b)) | (~state & (a ^ b));

// Output logic: define q as a combinational function of a, b, and state
assign q = (state & b) | (~state & a);

always @(posedge clk) begin
    state <= next_state;
end

endmodule