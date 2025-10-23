module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;

    always @(posedge clk) begin
        anyedge <= in ^ prev_in;  // Detect edges by XOR with previous input
        prev_in <= in;            // Update previous input after edge detection
    end
endmodule