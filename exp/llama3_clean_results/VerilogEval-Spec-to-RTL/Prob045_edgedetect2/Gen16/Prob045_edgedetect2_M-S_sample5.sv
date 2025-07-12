module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in = 0;  // Explicitly initialize previous state to zero

always @(posedge clk) begin
    anyedge <= in ^ prev_in;  // Detect edges using XOR
    prev_in <= in;  // Update previous state
end

endmodule