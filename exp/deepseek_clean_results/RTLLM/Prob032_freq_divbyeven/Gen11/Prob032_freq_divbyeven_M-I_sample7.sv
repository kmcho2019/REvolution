module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Must be even number (2, 4, 6, ...)

reg [3:0] cnt; // 4-bit counter as specified

// Validate parameter (synthesis-time check)
initial begin
    if (NUM_DIV[0] != 0) begin
        $error("NUM_DIV must be even number");
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'b0;
        clk_div <= 1'b0;
    end else begin
        if (cnt == (NUM_DIV/2)-1) begin
            cnt <= 4'b0;
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule