module TopModule (
    input wire clk,
    input wire reset,
    input wire [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edges;

    // Falling edge detection: prev_in = 1 and current in = 0
    assign falling_edges = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= in;   // Initialize prev_in to current input on reset
            out <= 32'b0;    // Clear output on reset
        end else begin
            out <= out | falling_edges; // Capture falling edges and hold
            prev_in <= in;              // Update prev_in for next cycle
        end
    end

endmodule