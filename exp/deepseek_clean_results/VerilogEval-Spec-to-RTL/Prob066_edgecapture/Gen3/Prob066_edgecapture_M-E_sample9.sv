module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] in_delayed;
    wire [31:0] falling_edge;

    // Edge detection: falling edge = 1 when in changes from 1 to 0
    assign falling_edge = in_delayed & ~in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            in_delayed <= 32'b0;
        end
        else begin
            // Capture any falling edges and maintain state until reset
            out <= out | falling_edge;
            // Store current input for next cycle comparison
            in_delayed <= in;
        end
    end

endmodule