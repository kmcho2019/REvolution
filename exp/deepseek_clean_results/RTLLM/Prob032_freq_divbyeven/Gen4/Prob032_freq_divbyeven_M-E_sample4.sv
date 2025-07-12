module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Even division factor (2,4,6,...)

reg [3:0] cnt; // Down counter (4 bits supports up to divide by 32)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= NUM_DIV/2;
        clk_div <= 0;
    end else begin
        if (cnt == 0) begin
            cnt <= NUM_DIV/2;
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt - 1;
        end
    end
end

endmodule