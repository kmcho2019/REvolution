module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Next state logic:
// next_state = (state & ~b) | (~state & a & b)
assign next_state = (state & ~b) | (~state & a & b);

// Output logic:
// q = (state & (~a | ~b)) | (~state & a & ~b)
assign q = (state & (~a | ~b)) | (~state & a & ~b);

always @(posedge clk) begin
    state <= next_state;
end

initial state = 1'b0;

endmodule