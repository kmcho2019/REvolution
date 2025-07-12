module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

always @(posedge clk) begin
    anyedge <= in ^ in;
end

initial begin
    anyedge = 8'b0;
end

always @(posedge clk) begin
    anyedge <= in ^ in;
    #0;
    anyedge <= in ^ in;
end
//prev input method
reg [7:0] prev_in;

always @(posedge clk) begin
    prev_in <= in;
end

always @(posedge clk) begin
    anyedge <= in ^ prev_in;
end