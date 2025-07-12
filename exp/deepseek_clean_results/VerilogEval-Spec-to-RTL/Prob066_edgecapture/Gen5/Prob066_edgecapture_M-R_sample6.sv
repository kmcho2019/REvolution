module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out <= 32'b0;
        end else begin
            // Store current input for next cycle comparison
            prev_in <= in;
            
            // Capture falling edges (1→0 transitions)
            // Each bit stays high once set until reset
            out <= out | (prev_in & ~in);
        end
    end

endmodule