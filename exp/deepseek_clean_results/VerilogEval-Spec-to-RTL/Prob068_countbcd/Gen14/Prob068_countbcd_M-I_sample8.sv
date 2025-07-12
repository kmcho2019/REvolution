module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    reg [2:0] ena_reg;
    
    wire [3:0] ones = counter[3:0];
    wire [3:0] tens = counter[7:4];
    wire [3:0] hundreds = counter[11:8];
    wire [3:0] thousands = counter[15:12];
    
    assign q = counter;
    assign ena = ena_reg;
    
    // Shared comparison signals
    wire ones_max = (ones == 4'd9);
    wire tens_max = (tens == 4'd9);
    wire hundreds_max = (hundreds == 4'd9);
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
            ena_reg <= 3'd0;
        end
        else begin
            // Calculate enable signals
            ena_reg[0] <= ones_max;
            ena_reg[1] <= ones_max & tens_max;
            ena_reg[2] <= ones_max & tens_max & hundreds_max;
            
            // Update counter with parallel logic
            if (ones_max) begin
                counter[3:0] <= 4'd0;
                
                if (tens_max) begin
                    counter[7:4] <= 4'd0;
                    
                    if (hundreds_max) begin
                        counter[11:8] <= 4'd0;
                        counter[15:12] <= (thousands == 4'd9) ? 4'd0 : thousands + 1;
                    end
                    else begin
                        counter[11:8] <= hundreds + 1;
                    end
                end
                else begin
                    counter[7:4] <= tens + 1;
                end
            end
            else begin
                counter[3:0] <= ones + 1;
            end
        end
    end

endmodule