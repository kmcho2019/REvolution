module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

// Initialize prev_in to a known state to minimize power-up transitions
reg [7:0] prev_in = 8'b0;

always @(posedge clk) begin
    anyedge <= in ^ prev_in;  // Efficient edge detection using XOR
    prev_in <= in;  // Update previous input state
end

endmodule