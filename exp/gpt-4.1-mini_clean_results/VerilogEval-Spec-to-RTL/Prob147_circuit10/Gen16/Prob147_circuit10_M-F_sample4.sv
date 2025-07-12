module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

// Next state logic as before:
wire next_state;
assign next_state = (state & ~(a & b)) | (~state & b);

// Output logic matches waveform observations:
assign q = (~state & b) | (state & ~a & ~b) | (state & a & b);

// State register with initialization to 0 for simulation stability:
initial state = 1'b0;

always @(posedge clk) begin
    state <= next_state;
end

endmodule