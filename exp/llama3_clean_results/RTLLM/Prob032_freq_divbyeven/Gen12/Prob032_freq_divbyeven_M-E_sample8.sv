// Novel frequency divider module
module freq_diveven #(
    parameter NUM_DIV = 2  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Calculate the required counter width based on NUM_DIV
localparam CNT_WIDTH = $clog2(NUM_DIV);

reg [CNT_WIDTH-1:0] cnt_stage1;  // First stage counter
reg [CNT_WIDTH-1:0] cnt_stage2;  // Second stage counter
reg rst_cnt;  // Reset counter signal

// Sequential logic for counter update and divided clock output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_stage1 <= 0;
        cnt_stage2 <= 0;
        rst_cnt <= 1;
        clk_div <= 0;
    end else if (rst_cnt) begin
        // Gradual reset mechanism
        if (cnt_stage1 == 0 && cnt_stage2 == 0) begin
            rst_cnt <= 0;
        end else begin
            if (cnt_stage2!= 0) begin
                cnt_stage2 <= cnt_stage2 - 1;
            end else if (cnt_stage1!= 0) begin
                cnt_stage1 <= cnt_stage1 - 1;
            end
        end
    end else if (cnt_stage2 == (NUM_DIV / 2 - 1)) begin
        cnt_stage1 <= 0;
        cnt_stage2 <= 0;
        clk_div <=!clk_div;
    end else if (cnt_stage1 == (NUM_DIV / 2 - 1)) begin
        cnt_stage1 <= 0;
        cnt_stage2 <= cnt_stage2 + 1;
    end else begin
        cnt_stage1 <= cnt_stage1 + 1;
    end
end

endmodule