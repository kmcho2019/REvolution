module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] prev_in;

    // Combinational falling edge detection
    wire [31:0] falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= in;    // Initialize prev_in to current input on reset
            out     <= 32'b0; // Clear captured output on reset
        end else begin
            prev_in <= in;
            out     <= out | falling_edge; // Latch detected falling edges
        end
    end

endmodule