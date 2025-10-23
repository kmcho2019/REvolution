module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
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

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'b0;
        clk_div <= 1'b0;
    end
    else begin
        if (cnt == DIV_HALF - 1) begin
            cnt <= 4'b0;
            clk_div <= ~clk_div;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule