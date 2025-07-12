module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] out_reg;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out_reg <= 32'b0;
        end else begin
            prev_in <= in;
            // For each bit, set output if we detect 1→0 transition
            // Once set, it stays set until reset
            out_reg <= out_reg | (prev_in & ~in);
        end
    end

    assign out = out_reg;

endmodule