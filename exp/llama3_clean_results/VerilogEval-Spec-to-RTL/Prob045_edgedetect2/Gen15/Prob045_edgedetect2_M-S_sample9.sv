module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

// Simplified pipeline stage for each bit of the input vector
always @(posedge clk) begin
    anyedge <= in ^ anyedge;
end

endmodule