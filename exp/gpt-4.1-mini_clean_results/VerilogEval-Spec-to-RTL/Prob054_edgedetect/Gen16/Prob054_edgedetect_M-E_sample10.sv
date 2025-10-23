module TopModule (
    input           clk,
    input   [7:0]   in,
    output  reg [7:0] pedge
);

    reg [7:0] prev_in;
    reg [7:0] detected_edge;

    always @(posedge clk) begin
        // Detect positive edges: bits that were 0 before and 1 now
        detected_edge <= (~prev_in) & in;
        // Output pedge delayed by one cycle
        pedge <= detected_edge;
        // Store current input for next cycle comparison
        prev_in <= in;
    end

endmodule