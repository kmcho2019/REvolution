module TopModule (
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_bits;
    wire [31:0] falling_edge;

    // Detect falling edge combinationally
    assign falling_edge = prev_bits & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_bits <= 32'b0;
            out <= 32'b0;
        end else begin
            prev_bits <= in;
            out <= out | falling_edge; // sticky capture of falling edges
        end
    end

endmodule