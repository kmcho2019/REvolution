module TopModule(
    input clk,
    input a,
    output reg q
);

reg next_q;

always @(posedge clk) begin
    case ({q, a})
        2'b00: next_q <= 1'b1;    // q=0, a=0 -> q=1
        2'b11: next_q <= 1'b0;    // q=1, a=1 -> q=0
        default: next_q <= q;     // otherwise hold
    endcase
    q <= next_q;
end

initial begin
    q = 1'bx;  // unknown initial state to match waveform
    next_q = 1'bx;
end

endmodule