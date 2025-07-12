module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

wire next_state;

assign next_state = (~state & ((b & ~a) | (~b & a))) | (state & ((a & b) | (~a & ~b)));

always @(posedge clk) begin
    state <= next_state;
end

assign q = next_state;

initial begin
    state = 0;
end

endmodule