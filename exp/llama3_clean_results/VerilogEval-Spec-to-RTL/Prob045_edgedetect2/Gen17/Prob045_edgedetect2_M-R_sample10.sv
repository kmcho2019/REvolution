module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in = 8'b0;  // Direct initialization for clarity and practice

always @(posedge clk) begin
    prev_in <= in;  // Update the previous state
end

assign anyedge = in ^ prev_in;  // Detect edges using XOR in combinational logic

endmodule