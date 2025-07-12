module TopModule(
    input clk,
    input a,
    output reg q
);

reg q_set = 0;

always @(posedge clk) begin
    if (!q_set && !a) begin
        q_set = 1;
        q = 1;
    end else if (q_set && a) begin
        q = ~q;
    end
end

endmodule