module TopModule (
    input clk,
    input a,
    output reg q
);

reg prev_a;

always @(posedge clk) begin
    if (a != prev_a) begin
        q <= ~q;
    end
    prev_a <= a;
end

endmodule