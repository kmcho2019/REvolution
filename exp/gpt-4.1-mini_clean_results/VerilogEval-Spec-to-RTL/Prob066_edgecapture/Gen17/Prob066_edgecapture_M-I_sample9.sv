module TopModule (
    input         clk,
    input         reset,
    input  [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out <= 32'b0;
        end else begin
            // Capture falling edges: bit was 1 and now 0
            out <= out | (prev_in & ~in);
            // Update previous input
            prev_in <= in;
        end
    end

endmodule