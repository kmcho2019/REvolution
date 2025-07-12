module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_state = 0;  // Initialize previous state to zero

always @(posedge clk) begin
    prev_state <= in;  // Update previous state with current input
    anyedge <= in ^ prev_state;  // Detect edges using XOR and assign to output
end

endmodule