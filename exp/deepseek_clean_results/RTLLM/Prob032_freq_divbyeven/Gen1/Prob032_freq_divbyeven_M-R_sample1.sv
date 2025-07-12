module freq_diveven #(
    parameter NUM_DIV = 4  // Default division factor (must be even)
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Check if NUM_DIV is even
initial begin
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be an even number");
        $finish;
    end
end

reg [3:0] cnt;          // 4-bit counter
reg toggle_flag;        // Flag to indicate when to toggle
reg clk_div_reg;        // Clock register

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'b0;
        toggle_flag <= 1'b0;
    end
    else begin
        if (cnt == (NUM_DIV/2 - 1)) begin
            cnt <= 4'b0;
            toggle_flag <= 1'b1;
        end
        else begin
            cnt <= cnt + 1;
            toggle_flag <= 1'b0;
        end
    end
end

// Clock generation logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_reg <= 1'b0;
    end
    else if (toggle_flag) begin
        clk_div_reg <= ~clk_div_reg;
    end
end

assign clk_div = clk_div_reg;

endmodule