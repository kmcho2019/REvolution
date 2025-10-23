module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edge;

    // Detect falling edges combinationally: previous bit 1, current bit 0
    assign falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out <= 32'b0;
        end else begin
            prev_in <= in;            // Store current input for next cycle
            out <= out | falling_edge; // Latch falling edge bits
        end
    end

endmodule