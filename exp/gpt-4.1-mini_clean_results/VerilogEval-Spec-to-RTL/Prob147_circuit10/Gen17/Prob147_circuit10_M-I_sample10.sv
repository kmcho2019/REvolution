module TopModule (
    input  clk,
    input  a,
    input  b,
    output reg state,
    output q
);

// Compute next state from current state and inputs
wire next_state;
assign next_state = (state & ~a) | (b & ~a) | (a & b & ~state);

// Output q logic inferred from waveform
assign q = (state & ~a) | (a & b);

always @(posedge clk) begin
    state <= next_state;
end

endmodule