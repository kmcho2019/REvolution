module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] edge_detect;
    reg [31:0] captured_edges;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            edge_detect <= 32'b0;
            captured_edges <= 32'b0;
            out <= 32'b0;
        end
        else begin
            // Stage 1: Store previous input
            prev_in <= in;
            
            // Stage 2: Detect falling edges
            edge_detect <= prev_in & ~in;
            
            // Capture any new falling edges
            captured_edges <= captured_edges | edge_detect;
            
            // Output the captured edges
            out <= captured_edges;
        end
    end

endmodule