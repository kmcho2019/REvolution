module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detected;
    reg [7:0] delayed_edge_detected;

    always @(posedge clk) begin
        // Detect edges by XOR-ing current input with previous input
        edge_detected <= prev_in ^ in;
        // Output edge detected in previous cycle (one cycle delay)
        anyedge <= delayed_edge_detected;
        // Delay edge_detected by one cycle for output in next cycle
        delayed_edge_detected <= edge_detected;
        // Update prev_in with current input
        prev_in <= in;
    end

endmodule