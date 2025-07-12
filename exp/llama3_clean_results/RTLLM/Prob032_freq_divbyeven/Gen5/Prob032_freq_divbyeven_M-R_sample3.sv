module freq_diveven (
    input  clk,    // Input clock signal
    input  rst_n,  // Active-low reset signal
    output reg clk_div  // Divided clock output signal
);

// Define the division factor as a parameter
parameter NUM_DIV = 8; // Must be an even number

// Counter register
reg [3:0] cnt; // 4-bit counter

// Initialize the counter and divided clock output
initial begin
    cnt = 0;
    clk_div = 0;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and divided clock output on reset
        cnt <= 0;
        clk_div <= 0;
    end else begin
        if (cnt < (NUM_DIV / 2) - 1) begin
            // Increment the counter
            cnt <= cnt + 1;
        end else begin
            // Reset the counter and toggle the divided clock output
            cnt <= 0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule