module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    assign q = counter;
    
    // Precompute all digit rollover conditions in parallel
    wire ones_rollover = (counter[3:0] == 4'd9);
    wire tens_rollover = (counter[7:4] == 4'd9);
    wire hundreds_rollover = (counter[11:8] == 4'd9);
    
    // Generate enable signals using lookahead logic
    assign ena[0] = ones_rollover;
    assign ena[1] = ones_rollover & tens_rollover;
    assign ena[2] = ones_rollover & tens_rollover & hundreds_rollover;
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end
        else begin
            // Process all digits in parallel
            // Ones digit (always increments)
            counter[3:0] <= (counter[3:0] == 4'd9) ? 4'd0 : counter[3:0] + 4'd1;
            
            // Tens digit (increments on ones rollover)
            if (ones_rollover) begin
                counter[7:4] <= (counter[7:4] == 4'd9) ? 4'd0 : counter[7:4] + 4'd1;
            end
            
            // Hundreds digit (increments on tens rollover)
            if (ones_rollover & tens_rollover) begin
                counter[11:8] <= (counter[11:8] == 4'd9) ? 4'd0 : counter[11:8] + 4'd1;
            end
            
            // Thousands digit (increments on hundreds rollover)
            if (ones_rollover & tens_rollover & hundreds_rollover) begin
                counter[15:12] <= (counter[15:12] == 4'd9) ? 4'd0 : counter[15:12] + 4'd1;
            end
        end
    end

endmodule