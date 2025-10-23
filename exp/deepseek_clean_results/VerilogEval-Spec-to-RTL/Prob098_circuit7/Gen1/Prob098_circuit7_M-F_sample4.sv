module TopModule (
    input clk,
    input a,
    output reg q = 0
);

reg prev_a;

initial begin
    prev_a = a;
end

always @(posedge clk) begin
    if (a != prev_a) begin
        q <= ~q;
    end
    prev_a <= a;
end

endmodule