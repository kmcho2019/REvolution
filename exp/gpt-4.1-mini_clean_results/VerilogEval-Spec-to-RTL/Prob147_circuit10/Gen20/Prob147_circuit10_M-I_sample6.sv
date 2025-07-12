module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

reg next_state;

// Combinational logic for next state calculation
always @(*) begin
    next_state = (state & ~(a & ~b)) | (~state & (b & ~a));
end

// Sequential logic: state update on positive edge of clk
always @(posedge clk) begin
    state <= next_state;
end

// Output q equals current state
assign q = state;

// Initialize state for deterministic simulation
initial begin
    state = 1'b0;
end

endmodule