module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

// Compute next state based on inputs and current state
wire set_state    = b & ~a;   // set to 1 if b=1 and a=0
wire reset_state  = a & b;    // reset to 0 if a=1 and b=1

wire next_state = set_state ? 1'b1 :
                  reset_state ? 1'b0 :
                  state;        // hold otherwise

// Output q is high if state is 1 or if both a and b are 1
assign q = state | (a & b);

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
end

endmodule