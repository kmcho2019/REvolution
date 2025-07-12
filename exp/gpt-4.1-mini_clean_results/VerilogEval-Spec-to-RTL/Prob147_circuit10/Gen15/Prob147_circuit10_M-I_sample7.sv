module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

assign next_state = b ? (a ? 1'b0 : ~state) : state;

always @(posedge clk) begin
    state <= next_state;
end

assign q = next_state;

initial begin
    state = 1'b0;
end

endmodule