module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detected;

    always @(posedge clk) begin
        // Detect edges comparing current input with previous input
        edge_detected <= prev_in ^ in;
        // Output the edge detection from previous cycle
        anyedge <= edge_detected;
        // Update prev_in with current input for next cycle comparison
        prev_in <= in;
    end

endmodule