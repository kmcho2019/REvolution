module freq_diveven #(
    parameter NUM_DIV = 2  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Check if NUM_DIV is an even number
initial begin
    if (NUM_DIV % 2 != 0) begin
        $fatal("NUM_DIV must be an even number.");
    end
end

// Calculate the required counter width based on NUM_DIV
localparam CNT_WIDTH = $clog2(NUM_DIV / 2);

reg [CNT_WIDTH-1:0] rise_cnt;  // Rising edge counter
reg [CNT_WIDTH-1:0] fall_cnt;  // Falling edge counter

// Counter update and divided clock output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rise_cnt <= '0;
        fall_cnt <= '0;
        clk_div <= '0;
    end else begin
        if (clk) begin
            rise_cnt <= (rise_cnt == (NUM_DIV / 2 - 1)) ? '0 : rise_cnt + 1;
        end else begin
            fall_cnt <= (fall_cnt == (NUM_DIV / 2 - 1)) ? '0 : fall_cnt + 1;
        end
        
        // Toggle divided clock output when both counters reach the specified limit
        if ((rise_cnt == (NUM_DIV / 2 - 1)) && (fall_cnt == (NUM_DIV / 2 - 1))) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule