module TopModule(
    input clk,
    input a,    // not used
    input b,
    output reg state,
    output q
);

always @(posedge clk) begin
    state <= b;
end

assign q = state;

initial begin
    state = 1'b0;
end

endmodule