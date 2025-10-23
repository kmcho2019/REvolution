module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

assign q = state;

always @(posedge clk) begin
    if (a & b)
        state <= ~state;
    else
        state <= state;
end

initial state = 1'b0;

endmodule