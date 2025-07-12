module TopModule (
    input             clk,
    input      [7:0]  in,
    output reg [7:0]  pedge
);

    reg [7:0] prev_in;          // Store previous input vector
    wire [7:0] pos_edge_detect; // Combinational detection of 0->1 transition

    // Detect positive edges by checking prev_in == 0 and in == 1 per bit
    assign pos_edge_detect = (~prev_in) & in;

    always @(posedge clk) begin
        prev_in <= in;           // Update previous input
        pedge   <= pos_edge_detect; // Register the detection output (delayed one cycle)
    end

endmodule