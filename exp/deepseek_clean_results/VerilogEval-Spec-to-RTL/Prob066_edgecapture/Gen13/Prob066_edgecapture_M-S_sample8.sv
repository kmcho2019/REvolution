module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] out_reg;

    assign out = out_reg;

    always @(posedge clk) begin
        if (reset) begin
            out_reg <= 32'b0;
        end
        else begin
            // Detect and capture falling edges (1->0 transitions)
            // out_reg serves as both storage and previous value
            out_reg <= out_reg | (in & ~out_reg) | (out_reg & ~in);
        end
    end

endmodule