module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    state <= ~b;
    if (b || (~a && state))
        q <= 1'b1;
    else
        q <= 1'b0;
end

endmodule