module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

// Compute next state based on current state and inputs
wire next_state;
assign next_state = (state & ~b) | (b & ~a);

// Compute output q as combinational function of a,b,state
assign q = (a & ~state) | (b & state);

// Sequential update of state on rising edge of clk
always @(posedge clk) begin
    state <= next_state;
end

endmodule