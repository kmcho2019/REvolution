module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] edge_latched;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            edge_latched <= 32'b0;
            out <= 32'b0;
        end else begin
            // Detect falling edges: prev_in=1 and current in=0
            wire [31:0] falling_edge = prev_in & ~in;
            edge_latched <= edge_latched | falling_edge; // latch detected edges
            out <= edge_latched;
            prev_in <= in;
        end
    end

endmodule