module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;
assign next_state = (state & ~(a & b)) | b;

assign q = state;

always @(posedge clk) begin
    state <= next_state;
end

endmodule