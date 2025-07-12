module TopModule (
    input             clk,
    input      [7:0]  in,
    output reg [7:0]  pedge
);

    reg [7:0] prev_in;            // Store previous input vector
    wire [7:0] pos_edge_detect;   // Combinational detection of 0->1 edges

    // Detect positive edges: previous bit == 0 and current bit == 1
    assign pos_edge_detect = (~prev_in) & in;

    always @(posedge clk) begin
        prev_in <= in;            // Register current input to prev_in
        pedge   <= pos_edge_detect; // Register detected edges for stable output, delayed by one cycle
    end

endmodule