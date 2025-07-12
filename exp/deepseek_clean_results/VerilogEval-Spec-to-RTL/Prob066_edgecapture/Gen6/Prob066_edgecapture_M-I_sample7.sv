module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] in_prev1, in_prev2;
    wire [31:0] falling_edge;

    // Falling edge detection between two consecutive cycles
    assign falling_edge = in_prev2 & ~in_prev1;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            in_prev1 <= 32'b0;
            in_prev2 <= 32'b0;
        end
        else begin
            // Shift pipeline
            in_prev2 <= in_prev1;
            in_prev1 <= in;
            
            // Capture any falling edges and maintain state until reset
            out <= out | falling_edge;
        end
    end

endmodule