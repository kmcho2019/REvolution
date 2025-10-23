module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// next_state logic:
// - Toggle state if both a and b are 1: state XOR (a & b)
// - Set state to 1 if currently 0 and inputs are a=0, b=1: (~state & ~a & b)
// Combined logic with OR to cover set and toggle conditions
assign next_state = (state ^ (a & b)) | (~state & ~a & b);

// Output logic: q = state OR (a & b)
assign q = state | (a & b);

always @(posedge clk) begin
    state <= next_state;
end

// Initialize state to 0 for simulation
initial begin
    state = 1'b0;
end

endmodule