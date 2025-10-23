module TopModule (
    input         clk,
    input         reset,
    input  [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= in;     // Initialize prev_in to current input to prevent missed edges after reset
            out <= 32'b0;      // Clear output on reset
        end else begin
            out <= out | (prev_in & ~in); // Capture falling edges
            prev_in <= in;
        end
    end

endmodule