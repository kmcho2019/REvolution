module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'b0;
        end
        else begin
            // Update output: maintain any previously set bits OR detect new falling edges
            out <= out | (prev_in & ~in);
            // Update previous input for next cycle's comparison
            prev_in <= in;
        end
    end

endmodule