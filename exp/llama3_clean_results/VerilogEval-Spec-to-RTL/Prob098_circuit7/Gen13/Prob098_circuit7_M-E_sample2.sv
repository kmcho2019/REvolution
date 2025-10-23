module TopModule(
    input clk,
    input a,
    output reg q
);

reg [1:0] count;

always @(posedge clk)
begin
    if (a) begin
        count <= count + 1;
    end
    if (count == 2) begin
        count <= 0;
        q <= ~q;
    end
end

endmodule