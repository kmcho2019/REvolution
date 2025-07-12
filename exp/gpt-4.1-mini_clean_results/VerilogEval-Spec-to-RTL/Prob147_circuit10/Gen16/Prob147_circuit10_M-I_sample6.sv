module TopModule (
    input  clk,
    input  a,
    input  b,
    output reg state,
    output q
);

wire next_state;

assign next_state = (~b & (state ^ a)) | (b & ~a & ~state) | (b & a & state);

always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

endmodule