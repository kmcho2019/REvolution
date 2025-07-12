module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the counter size (7 clock cycles)
localparam COUNTER_SIZE = 3;

// Counter for PWM
reg [COUNTER_SIZE-1:0] counter;

// Threshold for 3.5x frequency division (3.5/7 of counter range)
localparam THRESHOLD = 3'd2;  // 3.5/7 * (2^3 - 1)

// Output clock signal generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= '0;
        clk_div <= 1'b0;
    end else begin
        // Increment counter and check against threshold
        if (counter < (2**COUNTER_SIZE - 1)) begin
            counter <= counter + 1;
            if (counter < THRESHOLD) begin
                clk_div <= 1'b1;
            end else begin
                clk_div <= 1'b0;
            end
        end else begin
            counter <= '0;  // Reset counter
        end
    end
end

endmodule