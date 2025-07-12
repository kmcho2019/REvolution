module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    wire [3:0] ones = counter[3:0];
    wire [3:0] tens = counter[7:4];
    wire [3:0] hundreds = counter[11:8];
    wire [3:0] thousands = counter[15:12];
    
    wire ones_max = (ones == 4'd9);
    wire tens_max = (tens == 4'd9);
    wire hundreds_max = (hundreds == 4'd9);
    
    wire tens_inc = ones_max;
    wire hundreds_inc = ones_max & tens_max;
    wire thousands_inc = ones_max & tens_max & hundreds_max;
    
    assign q = counter;
    
    // Clock gating signals
    wire tens_clk_en = tens_inc | reset;
    wire hundreds_clk_en = hundreds_inc | reset;
    wire thousands_clk_en = thousands_inc | reset;
    
    always @(posedge clk) begin
        // Registered enable signals
        ena <= {thousands_inc, hundreds_inc, tens_inc};
        
        if (reset) begin
            counter <= 16'd0;
        end
        else begin
            // Always increment ones digit
            if (ones_max) begin
                counter[3:0] <= 4'd0;
            end
            else begin
                counter[3:0] <= ones + 1;
            end
            
            // Tens digit with clock gating
            if (tens_clk_en) begin
                if (ones_max) begin
                    if (tens_max) begin
                        counter[7:4] <= 4'd0;
                    end
                    else begin
                        counter[7:4] <= tens + 1;
                    end
                end
            end
            
            // Hundreds digit with clock gating
            if (hundreds_clk_en) begin
                if (hundreds_inc) begin
                    if (hundreds_max) begin
                        counter[11:8] <= 4'd0;
                    end
                    else begin
                        counter[11:8] <= hundreds + 1;
                    end
                end
            end
            
            // Thousands digit with clock gating
            if (thousands_clk_en) begin
                if (thousands_inc) begin
                    if (hundreds_max) begin
                        if (thousands == 4'd9) begin
                            counter[15:12] <= 4'd0;
                        end
                        else begin
                            counter[15:12] <= thousands + 1;
                        end
                    end
                end
            end
        end
    end

endmodule