module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] in_d1;       // Stage 1: input delay register
    reg [31:0] edge_detect;  // Stage 2: edge detection
    reg [31:0] sticky_out;   // Sticky output register

    always @(posedge clk) begin
        if (reset) begin
            in_d1 <= 32'b0;
            edge_detect <= 32'b0;
            sticky_out <= 32'b0;
        end else begin
            // Pipeline stage 1: capture current input
            in_d1 <= in;
            
            // Pipeline stage 2: detect falling edges
            edge_detect <= in_d1 & ~in;
            
            // Maintain sticky outputs (set on edge, cleared only by reset)
            sticky_out <= sticky_out | edge_detect;
        end
    end

    assign out = sticky_out;

endmodule