module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire state_next;

assign state_next = state ? ((a & b) | (~a & ~b)) : (b & ~a);
assign q = state | (a & b);

always @(posedge clk) begin
    state <= state_next;
end

initial begin
    state = 0;
end

endmodule