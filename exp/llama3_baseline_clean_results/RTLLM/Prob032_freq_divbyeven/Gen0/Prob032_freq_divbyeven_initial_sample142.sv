module freq_diveven(
    input clk,    // Input clock signal
    input rst_n,  // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Define the division factor (must be an even number)
parameter NUM_DIV = 8;  // Example division factor

// 4-bit counter to track the number of clock cycles
reg [3:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Initialize counter and divided clock signal on reset
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            // Increment counter without changing divided clock output
            cnt <= cnt + 1'd1;
        end else begin
            // Reset counter and toggle divided clock output
            cnt <= 4'd0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule