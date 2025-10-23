// Novel frequency divider module using a counter-based approach
module freq_diveven (
    input  wire clk,    // Input clock signal
    input  wire rst_n,  // Active-low reset signal
    output reg  clk_div  // Divided clock output signal
);

// Define the division factor as a parameter
parameter NUM_DIV = 8; // Must be an even number

// Counter to track input clock cycles
reg [3:0] cnt;

// Counter for divided clock generation
reg [3:0] clk_div_cnt;

// Always block for combined counter and output logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counters and output on reset
        cnt <= 4'd0;
        clk_div_cnt <= 4'd0;
        clk_div <= 1'b0;
    end else begin
        // Increment input clock cycle counter
        cnt <= cnt + 1;

        // Check if the counter has reached the threshold for toggling the output
        if (cnt == (NUM_DIV / 2 - 1)) begin
            // Reset the input clock cycle counter and toggle the divided clock counter
            cnt <= 4'd0;
            clk_div_cnt <= clk_div_cnt + 1;

            // Toggle the output clock signal when the divided clock counter reaches its threshold
            if (clk_div_cnt == 1'b1) begin
                clk_div <= ~clk_div;
                clk_div_cnt <= 4'd0;
            end
        end
    end
end

endmodule