module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    
    assign q = counter;
    
    // Enable signals
    assign ena[0] = (counter[3:0] == 4'd9);                          // tens enable
    assign ena[1] = (counter[7:4] == 4'd9) & ena[0];                 // hundreds enable
    assign ena[2] = (counter[11:8] == 4'd9) & ena[1];                // thousands enable
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end
        else begin
            // Increment ones digit
            counter[3:0] <= (counter[3:0] == 4'd9) ? 4'd0 : counter[3:0] + 4'd1;
            
            // Increment tens digit if ones overflow
            if (ena[0]) begin
                counter[7:4] <= (counter[7:4] == 4'd9) ? 4'd0 : counter[7:4] + 4'd1;
            end
            
            // Increment hundreds digit if tens overflow
            if (ena[1]) begin
                counter[11:8] <= (counter[11:8] == 4'd9) ? 4'd0 : counter[11:8] + 4'd1;
            end
            
            // Increment thousands digit if hundreds overflow
            if (ena[2]) begin
                counter[15:12] <= (counter[15:12] == 4'd9) ? 4'd0 : counter[15:12] + 4'd1;
            end
        end
    end

endmodule