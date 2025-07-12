module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    assign q = counter;
    
    // Parallel enable signal generation
    wire ones_rollover = (counter[3:0] == 4'd9);
    wire tens_rollover = (counter[7:4] == 4'd9);
    wire hundreds_rollover = (counter[11:8] == 4'd9);
    
    assign ena[0] = ones_rollover;
    assign ena[1] = ones_rollover & tens_rollover;
    assign ena[2] = ones_rollover & tens_rollover & hundreds_rollover;
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end
        else begin
            // Ones digit (always increments)
            counter[3:0] <= (counter[3:0] == 4'd9) ? 4'd0 : counter[3:0] + 4'd1;
            
            // Tens digit (increments on ones rollover)
            counter[7:4] <= ena[0] ? 
                           (counter[7:4] == 4'd9 ? 4'd0 : counter[7:4] + 4'd1) : 
                           counter[7:4];
            
            // Hundreds digit (increments on tens rollover)
            counter[11:8] <= ena[1] ? 
                            (counter[11:8] == 4'd9 ? 4'd0 : counter[11:8] + 4'd1) : 
                            counter[11:8];
            
            // Thousands digit (increments on hundreds rollover)
            counter[15:12] <= ena[2] ? 
                             (counter[15:12] == 4'd9 ? 4'd0 : counter[15:12] + 4'd1) : 
                             counter[15:12];
        end
    end

endmodule