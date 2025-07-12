module TopModule (
    input         clk,
    input         reset,
    input  [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edge;

    // Detect falling edges: bit was 1 before and now 0
    assign falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            // Initialize prev_in to current input to avoid false falling edges
            prev_in <= in;
            out <= 32'b0;
        end else begin
            prev_in <= in;
            out <= out | falling_edge;
        end
    end

endmodule