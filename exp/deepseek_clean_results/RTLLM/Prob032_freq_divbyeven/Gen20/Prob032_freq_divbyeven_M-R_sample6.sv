module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 6;  // Must be even number

// Check if NUM_DIV is even at elaboration time
generate
    if (NUM_DIV % 2 != 0) begin
        illegal_parameter_condition #(
            .ERROR_MSG("NUM_DIV must be an even number")
        ) param_check();
    end
endgenerate

localparam DIV_HALF = NUM_DIV / 2;
reg [3:0] cnt, next_cnt;
reg clk_div_reg;

// Combinational next state logic
always @(*) begin
    if (cnt == DIV_HALF - 1) begin
        next_cnt = 4'b0;
    end
    else begin
        next_cnt = cnt + 1;
    end
end

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'b0;
        clk_div_reg <= 1'b0;
    end
    else begin
        cnt <= next_cnt;
        if (next_cnt == 4'b0) begin
            clk_div_reg <= ~clk_div_reg;
        end
    end
end

// Output assignment
assign clk_div = clk_div_reg;

endmodule