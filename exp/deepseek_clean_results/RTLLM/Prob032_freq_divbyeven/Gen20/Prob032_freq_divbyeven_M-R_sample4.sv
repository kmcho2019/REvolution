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
reg [3:0] cnt;
reg clk_div_reg;

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'b0;
    end
    else begin
        if (cnt == DIV_HALF - 1) begin
            cnt <= 4'b0;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end

// Clock generation logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_reg <= 1'b0;
    end
    else begin
        if (cnt == DIV_HALF - 1) begin
            clk_div_reg <= ~clk_div_reg;
        end
    end
end

assign clk_div = clk_div_reg;

endmodule