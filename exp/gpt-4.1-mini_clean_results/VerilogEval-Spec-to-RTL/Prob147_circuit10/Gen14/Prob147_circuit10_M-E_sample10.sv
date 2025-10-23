module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire q_comb;

// Combinational logic derived from waveform analysis
assign q_comb = (state & ~b & ~a) | (~state & b) | (a & ~b);
assign q = q_comb;

always @(posedge clk) begin
    state <= q_comb;
end

endmodule