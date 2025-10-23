module freq_diveven (
    input  clk,    // Input clock signal
    input  rst_n,  // Active-low reset signal
    output reg clk_div  // Divided clock output signal
);

// Define the division factor as a parameter
parameter NUM_DIV = 8; // Must be an even number

// Define the counter width based on the division factor
localparam CNT_WIDTH = $clog2(NUM_DIV);

// Counter register
reg [CNT_WIDTH-1:0] cnt;

// Sequential logic block for the counter and divided clock
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and the divided clock output on reset
        cnt <= 0;
        clk_div <= 0;
    end else begin
        // If the counter is less than half of NUM_DIV - 1, increment it
        if (cnt < (NUM_DIV / 2) - 1) begin
            cnt <= cnt + 1;
        end else begin
            // If the counter reaches the limit, reset it and toggle the divided clock output
            cnt <= 0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule