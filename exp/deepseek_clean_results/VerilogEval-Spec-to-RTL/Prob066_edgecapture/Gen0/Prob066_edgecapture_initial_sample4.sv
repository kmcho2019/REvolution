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
            prev_in <= in;
            // For each bit, set output if we detect 1->0 transition
            // Once set, output stays 1 until reset
            out <= out | (prev_in & ~in);
        end
    end

endmodule