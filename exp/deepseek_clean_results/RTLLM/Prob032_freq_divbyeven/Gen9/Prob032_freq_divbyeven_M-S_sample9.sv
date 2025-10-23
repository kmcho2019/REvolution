module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Must be even number (2, 4, 6, ...)
localparam CNT_MAX = (NUM_DIV >> 1) - 1;

// Validate parameter at elaboration time
initial begin
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be even (given: %0d)", NUM_DIV);
        $finish;
    end
end

reg [$clog2(NUM_DIV)-1:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= '0;
        clk_div <= 1'b0;
    end else begin
        if (cnt == CNT_MAX) begin
            cnt <= '0;
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule