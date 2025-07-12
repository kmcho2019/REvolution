module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detected;

    always @(posedge clk) begin
        // Detect edges between current and previous input bits
        edge_detected <= in ^ prev_in;
        // Register output one cycle after edge detection
        anyedge <= edge_detected;
        // Update previous input
        prev_in <= in;
    end

endmodule