module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detected;

    always @(posedge clk) begin
        // Detect edges by XORing current and previous input
        edge_detected <= prev_in ^ in;
        // Output the edge detected in previous cycle
        anyedge <= edge_detected;
        // Store current input for next cycle comparison
        prev_in <= in;
    end

endmodule