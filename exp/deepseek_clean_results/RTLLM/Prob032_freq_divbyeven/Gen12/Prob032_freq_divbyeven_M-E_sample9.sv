module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Must be even number (2, 4, 6, ...)
reg [3:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= NUM_DIV >> 1; // Initialize to half of division factor
        clk_div <= 1'b0;
    end else begin
        if (cnt == 4'b0) begin
            clk_div <= ~clk_div;
            cnt <= (NUM_DIV >> 1) - 1'b1;
        end else begin
            cnt <= cnt - 1'b1;
        end
    end
end

endmodule