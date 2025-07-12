module TopModule (
    input  clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    reg [7:0] detected_edge;

    always @(posedge clk) begin
        // Detect 0->1 transition: previous bit 0 and current bit 1
        detected_edge <= (~prev_in) & in;
        // Output the detected edge from previous cycle
        pedge <= detected_edge;
        // Update previous input
        prev_in <= in;
    end

endmodule