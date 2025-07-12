module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 4;  // Must be even and >= 2

// Validate parameter
initial begin
    if (NUM_DIV < 2 || NUM_DIV[0] != 0) begin
        $error("NUM_DIV must be even and >= 2. Current value: %0d", NUM_DIV);
        $finish;
    end
end

reg [3:0] cnt;        // 4-bit counter
reg clk_div_reg;      // Output register
localparam CNT_LIMIT = (NUM_DIV/2) - 1;

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'b0;
    end
    else begin
        if (cnt == CNT_LIMIT) begin
            cnt <= 4'b0;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end

// Output generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_reg <= 1'b0;
    end
    else if (cnt == CNT_LIMIT) begin
        clk_div_reg <= ~clk_div_reg;
    end
end

assign clk_div = clk_div_reg;

endmodule