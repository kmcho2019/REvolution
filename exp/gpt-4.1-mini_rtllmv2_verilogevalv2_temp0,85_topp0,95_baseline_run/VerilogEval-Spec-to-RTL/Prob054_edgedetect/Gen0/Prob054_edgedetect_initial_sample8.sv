module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detected;

    always @(posedge clk) begin
        prev_in <= in;                      // Store previous input
        edge_detected <= (~prev_in) & in;  // Detect 0 to 1 transitions
        pedge <= edge_detected;             // Output the detection from previous cycle
    end

endmodule