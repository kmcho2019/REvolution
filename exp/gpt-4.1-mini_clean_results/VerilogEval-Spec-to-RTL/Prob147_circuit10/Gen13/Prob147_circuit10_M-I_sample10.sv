module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state = (state & ~(a & b)) | (b & ~a);

always @(posedge clk) begin
    state <= next_state;
end

assign q = (state & ~a) | (~state & b);

initial state = 1'b0;

endmodule