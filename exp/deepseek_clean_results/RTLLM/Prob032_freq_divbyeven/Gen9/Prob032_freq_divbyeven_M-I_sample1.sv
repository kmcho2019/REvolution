module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Must be even number (2, 4, 6, ...)

reg [3:0] cnt; // 4-bit counter supports division up to 30

// Counter and clock division logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end else begin
        if (cnt == (NUM_DIV/2 - 1)) begin
            cnt <= 0;
            clk_div <= ~clk_div; // Toggle every NUM_DIV/2 cycles
        end else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule