module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    // Stage 1: Input capture registers
    reg [31:0] stage1_reg;

    // Stage 2: Previous value registers for edge detection
    reg [31:0] stage2_reg;

    // Sticky output registers
    reg [31:0] sticky_out;

    always @(posedge clk) begin
        if (reset) begin
            stage1_reg <= 32'b0;
            stage2_reg <= 32'b0;
            sticky_out <= 32'b0;
        end else begin
            // Pipeline stages
            stage1_reg <= in;
            stage2_reg <= stage1_reg;

            // Falling edge detection and sticky output
            for (integer i = 0; i < 32; i = i + 1) begin
                if (stage1_reg[i] && !stage2_reg[i]) begin
                    sticky_out[i] <= 1'b1;
                end
            end
        end
    end

    assign out = sticky_out;

endmodule