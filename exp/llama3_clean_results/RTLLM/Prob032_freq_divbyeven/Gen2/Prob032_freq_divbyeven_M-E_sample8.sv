module freq_diveven (
    input  clk,    // Input clock signal
    input  rst_n,  // Active-low reset signal
    output reg clk_div  // Divided clock output signal
);

// Define the division factor as a parameter
parameter NUM_DIV = 8; // Must be an even number

// Counter register
reg [3:0] cnt;

// Internal wire for the divided clock
reg clk_div_int;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and the divided clock output on reset
        cnt <= 0;
        clk_div_int <= 0;
    end else begin
        // If the counter is less than NUM_DIV / 2, increment it
        if (cnt < (NUM_DIV / 2)) begin
            cnt <= cnt + 1;
        end else begin
            // If the counter reaches the limit, reset it and toggle the divided clock output
            cnt <= 0;
            clk_div_int <= ~clk_div_int;
        end
    end
end

// Assign the internal divided clock wire to the output
assign clk_div = clk_div_int;

endmodule