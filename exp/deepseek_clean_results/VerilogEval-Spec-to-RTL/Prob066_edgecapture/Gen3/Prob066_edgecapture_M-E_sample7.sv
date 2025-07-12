module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    // One-cycle delayed version of input
    reg [31:0] in_delayed;
    
    // Falling edge detection flip-flops
    reg [31:0] edge_capture;

    always @(posedge clk) begin
        if (reset) begin
            in_delayed <= 32'b0;
            edge_capture <= 32'b0;
        end else begin
            in_delayed <= in;
            // Detect falling edges (1->0 transitions)
            edge_capture <= edge_capture | (in_delayed & ~in);
        end
    end

    assign out = edge_capture;

endmodule