module freq_diveven (
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4;  // Division factor (must be even >= 2)

// Calculate required counter width based on parameter
localparam CNT_WIDTH = $clog2(NUM_DIV/2);
localparam CNT_MAX = NUM_DIV/2 - 1;

// Validate parameter (synthesis-time check)
generate
    if (NUM_DIV[0] || NUM_DIV < 2) begin
        initial $error("NUM_DIV must be an even number >= 2");
    end
endgenerate

reg [CNT_WIDTH-1:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end
    else begin
        if (cnt == CNT_MAX) begin
            cnt <= 0;
            clk_div <= ~clk_div;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule