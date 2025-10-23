module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] falling_edge_capture;

    wire [31:0] falling_edges;
    assign falling_edges = prev_in & (~in);

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            falling_edge_capture <= 32'b0;
            out <= 32'b0;
        end else begin
            falling_edge_capture <= falling_edge_capture | falling_edges;
            out <= falling_edge_capture | falling_edges;
            prev_in <= in;
        end
    end

endmodule