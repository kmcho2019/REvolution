module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edge;

    // Combinational falling edge detection
    assign falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'b0;
        end
        else begin
            // Accumulate any detected falling edges
            out <= out | falling_edge;
            // Store current input for next cycle
            prev_in <= in;
        end
    end

endmodule