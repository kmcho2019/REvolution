module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

always @(posedge clk) begin
    if (a == 1'b0 && b == 1'b1) state <= 1'b1;
    else if (a == 1'b1 && b == 1'b1) state <= 1'b0;
    else state <= state;
end

assign q = (state == 1'b1) || (a == 1'b1 && b == 1'b0);

endmodule