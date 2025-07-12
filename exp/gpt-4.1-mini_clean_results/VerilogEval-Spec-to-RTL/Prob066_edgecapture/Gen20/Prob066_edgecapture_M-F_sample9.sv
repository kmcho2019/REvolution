module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edges;

    // Combinational detection of falling edges
    assign falling_edges = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            // On reset assertion, initialize prev_in once to input to avoid false edges
            prev_in <= in;
            out <= 32'b0;  // Clear output on reset
        end else begin
            prev_in <= in;
            out <= out | falling_edges;
        end
    end

endmodule