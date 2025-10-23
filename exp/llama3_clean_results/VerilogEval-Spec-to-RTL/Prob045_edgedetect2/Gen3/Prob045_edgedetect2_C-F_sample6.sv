module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in = 8'b0; // Initialize prev_in to 0

always @(posedge clk) begin
    prev_in <= in; // Update prev_in at the positive edge of the clock
    anyedge = prev_in ^ in; // Calculate anyedge immediately
end

endmodule