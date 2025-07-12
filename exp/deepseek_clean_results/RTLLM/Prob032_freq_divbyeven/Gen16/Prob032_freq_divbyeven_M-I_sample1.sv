module freq_diveven (
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6;  // Must be even number >= 2

// Validate parameter (synthesis-friendly)
generate
    if (NUM_DIV[0] || NUM_DIV < 2) begin
        illegal_parameter_condition #(
            .ERROR_MSG("NUM_DIV must be an even number >= 2")
        ) param_check ();
    end
endgenerate

localparam TERM_CNT = NUM_DIV/2 - 1;
reg [3:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'b0;
        clk_div <= 1'b0;
    end
    else begin
        if (cnt == TERM_CNT) begin
            cnt <= 4'b0;
            clk_div <= ~clk_div;
        end
        else begin
            cnt <= cnt + 1'b1;
        end
    end
end

endmodule