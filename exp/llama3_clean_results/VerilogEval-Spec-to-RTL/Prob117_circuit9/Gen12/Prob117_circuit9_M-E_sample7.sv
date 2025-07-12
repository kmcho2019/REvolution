module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] count;

always @(posedge clk)
begin
    if (a)
        count <= 4;
    else
        count <= count + 1;
end

assign q = count;

endmodule