module TopModule (
    input clk,
    input a,
    output reg q
);

reg a_prev;

always @(posedge clk) begin
    if (a != a_prev) begin  // detect change in input
        q <= ~q;            // toggle output
    end
    a_prev <= a;            // store current input for next cycle
end

endmodule