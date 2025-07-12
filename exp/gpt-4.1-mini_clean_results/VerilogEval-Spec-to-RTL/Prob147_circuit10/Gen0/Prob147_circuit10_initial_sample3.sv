module TopModule (
    input  clk,
    input  a,
    input  b,
    output reg state,
    output     q
);

wire next_state;

assign next_state = (~a) & ( (state & (~b)) | ((~state) & b) );

assign q = next_state;

always @(posedge clk) begin
    state <= next_state;
end

endmodule