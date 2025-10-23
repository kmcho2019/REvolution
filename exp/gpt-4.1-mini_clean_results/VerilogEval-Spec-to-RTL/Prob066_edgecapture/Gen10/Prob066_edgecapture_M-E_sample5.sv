module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] falling_edge_capture;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            falling_edge_capture <= 32'b0;
            out <= 32'b0;
        end else begin
            // Detect falling edge bits where prev_in was 1 and current in is 0
            wire [31:0] falling_edges = prev_in & (~in);

            // Capture all falling edges until reset
            falling_edge_capture <= falling_edge_capture | falling_edges;

            // Update output and previous input registers
            out <= falling_edge_capture | falling_edges;
            prev_in <= in;
        end
    end

endmodule