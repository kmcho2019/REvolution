module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in;
reg [31:0] prev_prev_in;
reg [31:0] edge_latch;

always @(posedge clk) begin
    if (reset) begin
        out <= 32'b0;
        prev_in <= 32'b0;
        prev_prev_in <= 32'b0;
        edge_latch <= 32'b0;
    end
    else begin
        // Shift the input pipeline
        prev_prev_in <= prev_in;
        prev_in <= in;
        
        // Detect falling edges (1->0 transitions between two cycles ago and one cycle ago)
        for (integer i = 0; i < 32; i = i + 1) begin
            if (prev_prev_in[i] && !prev_in[i]) begin
                edge_latch[i] <= 1'b1;
            end
        end
        
        // Output is the OR of current edge detections and previously latched edges
        out <= edge_latch;
    end
end

endmodule