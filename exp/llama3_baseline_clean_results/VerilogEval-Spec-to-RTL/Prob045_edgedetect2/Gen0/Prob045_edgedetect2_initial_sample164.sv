module TopModule(
    input           clk,
    input   [7:0]   in,
    output  [7:0]   anyedge
);

reg [7:0] prev_in;
reg [7:0] anyedge;

always @(posedge clk) begin
    anyedge <= (in ^ prev_in);  // XOR operation to detect edge
    prev_in <= in;  // Update previous state
end

endmodule