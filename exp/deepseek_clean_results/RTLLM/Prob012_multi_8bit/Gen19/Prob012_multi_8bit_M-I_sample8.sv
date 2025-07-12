module multi_8bit (
    input clk,
    input reset,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    reg [2:0] count;
    reg [15:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accumulator;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'b0;
            multiplicand <= {8'b0, A};
            multiplier <= B;
            accumulator <= 16'b0;
            product <= 16'b0;
        end else begin
            if (count < 3'd7) begin
                // Shift multiplicand left
                multiplicand <= multiplicand << 1;
                
                // Add to accumulator if multiplier bit is set
                if (multiplier[0])
                    accumulator <= accumulator + multiplicand;
                
                // Shift multiplier right
                multiplier <= multiplier >> 1;
                
                // Increment counter
                count <= count + 1;
            end else begin
                // Final addition if needed
                if (multiplier[0])
                    product <= accumulator + multiplicand;
                else
                    product <= accumulator;
            end
        end
    end

endmodule