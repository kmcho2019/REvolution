module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

assign q = (state & ~b) | (~state & b & ~a);
assign next_state = (state & ~(a & b)) | (~state & b & ~a);

always @(posedge clk) begin
    state <= next_state;
end

endmodule