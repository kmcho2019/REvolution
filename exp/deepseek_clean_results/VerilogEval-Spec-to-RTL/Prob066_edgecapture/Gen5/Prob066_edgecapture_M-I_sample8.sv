module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] in_prev;
    wire [31:0] falling_edge;

    // Falling edge detection: 1 in previous cycle, 0 in current cycle
    assign falling_edge = in_prev & ~in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            in_prev <= 32'b0;
        end
        else begin
            in_prev <= in;
            // Capture any falling edges and maintain state until reset
            out <= out | falling_edge;
        end
    end

endmodule