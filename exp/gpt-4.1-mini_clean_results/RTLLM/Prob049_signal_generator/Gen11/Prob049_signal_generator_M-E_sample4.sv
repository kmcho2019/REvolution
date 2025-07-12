module signal_generator (
    input           clk,
    input           rst_n,
    output reg [4:0] wave
);

    reg signed [6:0] counter;   // Signed 7-bit counter for value and direction
    reg signed [6:0] step;      // Signed step (+1 or -1)

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            counter <= 7'sd0;  // Start at 0
            step <= 7'sd1;     // Initial direction: increment
            wave <= 5'd0;
        end else begin
            counter <= counter + step;

            // Check boundaries on counter's absolute 5 LSB value
            if (counter[4:0] == 5'd31 && step > 0) begin
                step <= -step;  // Reverse direction to decrement
            end else if (counter[4:0] == 5'd0 && step < 0) begin
                step <= -step;  // Reverse direction to increment
            end

            // wave is absolute value of 5 LSBs of counter
            wave <= counter[6] ? (~counter[4:0] + 1'b1) : counter[4:0];
        end
    end

endmodule