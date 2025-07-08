module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detected;

    always @(posedge clk) begin
        // Detect edges by comparing current input with previous input
        edge_detected <= in ^ prev_in;
        // Register the output one clock cycle after the edge detection
        anyedge <= edge_detected;
        // Store current input as previous input for next cycle
        prev_in <= in;
    end

endmodule