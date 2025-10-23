module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Next state logic derived from waveform analysis
assign next_state = (state & ~(a & b)) | (~state & (~a & b));

// Output q equals current state
assign q = state;

// State update at positive clock edge, initialized to 0
always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 0;
end

endmodule