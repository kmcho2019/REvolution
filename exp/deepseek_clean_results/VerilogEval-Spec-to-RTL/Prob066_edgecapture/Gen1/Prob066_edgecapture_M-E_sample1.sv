module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] stage1_reg, stage2_reg;
    reg [31:0] captured_state;

    always @(posedge clk) begin
        if (reset) begin
            stage1_reg <= 32'b0;
            stage2_reg <= 32'b0;
            captured_state <= 32'b0;
        end
        else begin
            // Pipeline stage 1: capture current input
            stage1_reg <= in;
            
            // Pipeline stage 2: capture previous input
            stage2_reg <= stage1_reg;
            
            // Update captured state only when 1->0 transition detected
            captured_state <= captured_state | (stage2_reg & ~stage1_reg);
        end
    end

    assign out = captured_state;

endmodule