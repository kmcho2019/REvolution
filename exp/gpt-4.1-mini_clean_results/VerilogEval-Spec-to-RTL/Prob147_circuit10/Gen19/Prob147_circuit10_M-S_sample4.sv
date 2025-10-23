module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

always @(posedge clk) begin
    if (b)
        state <= a;
    else
        state <= state;
end

assign q = state;

endmodule