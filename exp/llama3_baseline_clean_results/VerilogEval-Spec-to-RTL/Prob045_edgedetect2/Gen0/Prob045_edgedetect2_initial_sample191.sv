module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    prev_in <= in;
end

always @(posedge clk) begin
    anyedge <= (in ^ prev_in);
end

initial begin
    prev_in = 8'b0;
end

endmodule