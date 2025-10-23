module TopModule (
    input  clk,
    input  a,
    input  b,
    output reg state,
    output      q
);

// next_state logic: toggle state when b=1 and a=0; otherwise hold state
wire next_state = (b & ~a) ^ state;

// q output logic: when b=1, q = a ^ state; else q = state
assign q = (b & (a ^ state)) | (~b & state);

always @(posedge clk) begin
    state <= next_state;
end

endmodule