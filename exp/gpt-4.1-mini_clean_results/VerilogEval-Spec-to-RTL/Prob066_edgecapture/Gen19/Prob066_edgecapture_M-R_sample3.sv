module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] prev_in;

    wire [31:0] falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= in;    // Initialize prev_in to current input to avoid false edges
            out <= 32'b0;
        end else begin
            prev_in <= in;
            out <= out | falling_edge; // latch falling edges permanently until reset
        end
    end

endmodule