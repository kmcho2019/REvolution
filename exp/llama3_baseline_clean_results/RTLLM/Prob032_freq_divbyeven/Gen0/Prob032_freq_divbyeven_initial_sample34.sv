module freq_diveven #(
    parameter NUM_DIV = 4 // Division factor, must be an even number
) (
    input  wire clk,    // Input clock signal
    input  wire rst_n,  // Active-low reset signal
    output wire clk_div // Divided clock output signal
);

reg [3:0] cnt; // 4-bit counter
reg       clk_div_reg; // Register to hold the divided clock signal

// Calculate the specified limit for the counter
localparam integer LIMIT = (NUM_DIV / 2) - 1;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Initialize counter and divided clock signal to zero on reset
        cnt <= 4'b0;
        clk_div_reg <= 1'b0;
    end else begin
        if (cnt < LIMIT) begin
            // Increment counter if it is less than the specified limit
            cnt <= cnt + 1;
        end else begin
            // Reset counter and toggle divided clock signal when limit is reached
            cnt <= 4'b0;
            clk_div_reg <= ~clk_div_reg;
        end
    end
end

// Assign the divided clock signal to the output port
assign clk_div = clk_div_reg;

endmodule