module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    // Combinational positive edge detection for each bit
    wire [7:0] pos_edge_detect = (~prev_in) & in;

    always @(posedge clk) begin
        pedge   <= pos_edge_detect; // Register the detected edges
        prev_in <= in;              // Update previous input
    end

endmodule