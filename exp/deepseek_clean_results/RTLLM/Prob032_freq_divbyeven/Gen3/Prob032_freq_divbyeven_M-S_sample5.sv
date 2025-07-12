module freq_diveven (
    input wire clk,
    input wire rst_n,        // Asynchronous reset (active low)
    output wire clk_div     // Divided clock output
);

parameter NUM_DIV = 4;      // Division factor (must be even)

// Validate parameter
initial begin
    if (NUM_DIV < 2 || NUM_DIV[0] != 0) begin
        $error("Error: NUM_DIV must be even and >= 2");
    end
end

reg [3:0] cnt;              // 4-bit counter (handles up to divide by 32)
reg div_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        div_reg <= 0;
    end
    else begin
        if (cnt == (NUM_DIV/2 - 1)) begin
            cnt <= 0;
            div_reg <= ~div_reg;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end

assign clk_div = div_reg;

endmodule