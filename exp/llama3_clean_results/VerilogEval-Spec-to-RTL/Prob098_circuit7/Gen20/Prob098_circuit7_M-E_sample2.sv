module TopModule(
    input clk,
    input a,
    output reg q
);

reg [1:0] counter;

always @(posedge clk) begin
    if (!a) counter <= 0;
    else if (counter < 2) counter <= counter + 1;
    else counter <= counter;
end

always @(*) begin
    if (counter < 2) q = 1'b1;
    else q = 1'b0;
end

endmodule