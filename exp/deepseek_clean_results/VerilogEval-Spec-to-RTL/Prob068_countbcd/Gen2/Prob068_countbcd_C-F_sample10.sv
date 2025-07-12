module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;
    
    // Shared comparison terms
    wire ones_max = (ones == 4'd9);
    wire tens_max = (tens == 4'd9);
    wire hundreds_max = (hundreds == 4'd9);
    wire thousands_max = (thousands == 4'd9);
    
    // Registered enable signals
    reg [2:0] ena_reg;
    assign ena = ena_reg;
    assign q = {thousands, hundreds, tens, ones};
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            ena_reg <= 3'b0;
        end
        else begin
            // Update enable signals first
            ena_reg[0] <= ones_max;
            ena_reg[1] <= ones_max & tens_max;
            ena_reg[2] <= ones_max & tens_max & hundreds_max;
            
            // Ones digit - increments every cycle
            ones <= ones_max ? 4'd0 : ones + 4'd1;
            
            // Tens digit - increments when ones rolls over
            if (ones_max) begin
                tens <= tens_max ? 4'd0 : tens + 4'd1;
            end
            
            // Hundreds digit - increments when tens rolls over
            if (ones_max && tens_max) begin
                hundreds <= hundreds_max ? 4'd0 : hundreds + 4'd1;
            end
            
            // Thousands digit - increments when hundreds rolls over
            if (ones_max && tens_max && hundreds_max) begin
                thousands <= thousands_max ? 4'd0 : thousands + 4'd1;
            end
        end
    end

endmodule