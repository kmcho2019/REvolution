module TopModule(
    input           clk,
    input  [7:0]     in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    anyedge <= (in !== prev_in); // !== is not a standard Verilog operator, using ~= instead
    prev_in <= in;
end

endmodule