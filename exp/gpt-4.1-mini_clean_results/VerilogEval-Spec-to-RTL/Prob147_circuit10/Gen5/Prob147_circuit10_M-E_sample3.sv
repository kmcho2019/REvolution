module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Next state logic based on inputs and current state
assign next_state = (b & ~a) ? 1'b1 :
                    (b & a)  ? ~state :
                               state;

// Output logic: q is 1 if state=1 and not (a=1 and b=1), else 0
assign q = state & ~(a & b);

// State update on rising clock edge
always @(posedge clk) begin
    state <= next_state;
end

// Initialize state to 0 for deterministic start
initial begin
    state = 1'b0;
end

endmodule