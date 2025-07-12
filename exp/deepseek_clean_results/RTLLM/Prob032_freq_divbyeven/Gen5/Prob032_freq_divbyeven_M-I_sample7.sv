module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Must be even number (2, 4, 6, ...)
localparam DIV_HALF = NUM_DIV/2 - 1;

// Check parameter validity at compile time
initial begin
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be even, got %0d", NUM_DIV);
        $finish;
    end
end

reg [3:0] cnt; // 4-bit counter supports division up to 30

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end else begin
        cnt <= (cnt == DIV_HALF) ? 0 : cnt + 1;
        if (cnt == DIV_HALF)
            clk_div <= ~clk_div;
    end
end

endmodule