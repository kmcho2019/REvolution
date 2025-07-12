module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] in_delayed;
    reg [31:0] latched_edges;

    assign out = latched_edges;

    // Edge detection and latching
    always @(posedge clk) begin
        if (reset) begin
            latched_edges <= 32'b0;
            in_delayed <= 32'b0;
        end else begin
            // Store previous input
            in_delayed <= in;
            
            // Detect falling edges and latch them
            latched_edges <= latched_edges | ((in_delayed ^ in) & in_delayed);
        end
    end

endmodule