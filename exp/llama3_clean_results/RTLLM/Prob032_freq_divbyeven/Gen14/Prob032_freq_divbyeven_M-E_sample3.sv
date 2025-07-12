module freq_diveven #(
    parameter NUM_DIV = 4  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Validate NUM_DIV as an even number and greater than 1 at compile-time
initial begin
    if (NUM_DIV % 2!= 0) begin
        $error("NUM_DIV must be an even number.");
        $finish;
    end
    if (NUM_DIV < 2) begin
        $error("NUM_DIV must be greater than 1.");
        $finish;
    end
end

reg [NUM_DIV-1:0] ring_cnt;  // Ring counter

// Initialize ring counter with '1' at the first stage and '0's elsewhere
initial begin
    ring_cnt = {1'b1, {NUM_DIV-1{1'b0}}};
end

// Sequential logic for ring counter update and divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ring_cnt <= {1'b1, {NUM_DIV-1{1'b0}}};
        clk_div <= 1'b0;
    end else begin
        // Shift the ring counter
        ring_cnt <= {ring_cnt[NUM_DIV-2:0], ring_cnt[NUM_DIV-1]};
        
        // Toggle clk_div when the '1' reaches the middle of the ring counter
        if (ring_cnt[NUM_DIV/2-1] == 1'b1) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule