// Refactored frequency divider module
module freq_divbyeven #(
    parameter NUM_DIV = 2  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Check if NUM_DIV is an even number
initial begin
    if (NUM_DIV % 2!= 0) begin
        $fatal("NUM_DIV must be an even number.");
    end
end

// Calculate the required counter width based on NUM_DIV
localparam CNT_WIDTH = $clog2((NUM_DIV / 2) + 1);  // Ensure sufficient width

reg [CNT_WIDTH-1:0] cnt;  // Counter
reg clk_div_reg;         // Register for divided clock output

// Sequential logic for counter update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= '0;
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        cnt <= '0;
    end else begin
        cnt <= cnt + 1;
    end
end

// Combinational logic for divided clock output
always @(*) begin
    if (!rst_n) begin
        clk_div_reg = 1'b0;
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        clk_div_reg = ~clk_div_reg;
    end else begin
        clk_div_reg = clk_div_reg;
    end
end

// Continuous assignment for output
assign clk_div = clk_div_reg;

endmodule