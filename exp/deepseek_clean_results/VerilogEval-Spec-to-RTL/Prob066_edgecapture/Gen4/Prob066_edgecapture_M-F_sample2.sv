module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] in_prev, in_prev2;
    wire [31:0] falling_edge;

    // Falling edge detection: 1 in previous cycle, 0 in current cycle
    assign falling_edge = in_prev2 & ~in_prev;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            in_prev <= 32'b0;
            in_prev2 <= 32'b0;
        end
        else begin
            // Pipeline the input for stable edge detection
            in_prev2 <= in_prev;
            in_prev <= in;
            
            // Capture any falling edges and maintain state until reset
            out <= out | falling_edge;
        end
    end

endmodule