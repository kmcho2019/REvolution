module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

always @(posedge clk) begin
    if (a & b)
        state <= ~state;
    else if (~a & b)
        state <= 1'b1;
    else
        state <= 1'b0;
end

assign q = state;

initial begin
    state = 0;
end

endmodule