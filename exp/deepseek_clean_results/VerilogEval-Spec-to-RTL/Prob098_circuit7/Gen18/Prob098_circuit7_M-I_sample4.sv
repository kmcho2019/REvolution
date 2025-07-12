module TopModule (
    input clk,
    input a,
    output reg q
);

reg a_prev;
wire clk_en = (a != a_prev);

always @(posedge clk) begin
    a_prev <= a;
    if (clk_en) begin
        if (a) q <= 0;
        else q <= 1;
    end
end

endmodule