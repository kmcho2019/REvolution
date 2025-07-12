module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state = b ? a : state;

always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

endmodule