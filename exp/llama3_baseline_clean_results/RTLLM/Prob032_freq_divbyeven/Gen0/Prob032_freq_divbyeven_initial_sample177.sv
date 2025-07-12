module freq_diveven #
(
    parameter NUM_DIV = 10  // Division factor, must be an even number
)
(
    input  logic        clk,      // Input clock signal
    input  logic        rst_n,    // Active-low reset signal
    output logic        clk_div   // Divided clock output signal
);

// Counter register declaration
logic [3:0] cnt;

// Divided clock output signal declaration
logic clk_div_reg;

// Assign output to internal signal
assign clk_div = clk_div_reg;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and divided clock signal on reset
        cnt     <= '0;
        clk_div_reg <= '0;
    end else begin
        // Check if counter has reached the specified limit
        if (cnt == (NUM_DIV / 2 - 1)) begin
            // Reset counter and toggle divided clock signal
            cnt     <= '0;
            clk_div_reg <= ~clk_div_reg;
        end else begin
            // Increment counter on each positive edge of input clock
            cnt <= cnt + 1;
        end
    end
end

endmodule