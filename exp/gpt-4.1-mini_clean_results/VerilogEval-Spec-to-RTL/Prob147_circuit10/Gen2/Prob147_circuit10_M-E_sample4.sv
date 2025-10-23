module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

wire next_state;

// Next state logic: set state if b=1 and a=0, clear or hold otherwise, with toggle behavior when a&b=1
assign next_state = (state & ~(a & b)) | (~state & b & ~a);

// Output q logic: depends on state and inputs
assign q = (state & b) | (~state & a);

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 0;
end

endmodule