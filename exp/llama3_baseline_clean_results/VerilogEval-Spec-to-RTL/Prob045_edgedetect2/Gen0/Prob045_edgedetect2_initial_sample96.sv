module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;
reg [7:0] anyedge_reg;

initial begin
    prev_in = 8'b0;
    anyedge_reg = 8'b0;
end

always @(posedge clk) begin
    anyedge_reg <= (in != prev_in);
    prev_in <= in;
end

assign anyedge = anyedge_reg;

endmodule