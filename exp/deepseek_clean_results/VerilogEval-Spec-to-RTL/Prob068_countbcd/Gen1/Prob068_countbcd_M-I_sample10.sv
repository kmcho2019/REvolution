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
    
    // Registered enable signals
    reg [2:0] ena_reg;
    assign ena = ena_reg;
    
    // Common comparison terms
    wire ones_max = (ones == 4'd9);
    wire tens_max = (tens == 4'd9);
    wire hundreds_max = (hundreds == 4'd9);
    
    // Combinational enable logic (simplified)
    wire [2:0] ena_next;
    assign ena_next[0] = ones_max;
    assign ena_next[1] = ones_max & tens_max;
    assign ena_next[2] = ones_max & tens_max & hundreds_max;
    
    // Combine digits into output
    assign q = {thousands, hundreds, tens, ones};
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            ena_reg <= 3'b0;
        end else begin
            // Register enable signals
            ena_reg <= ena_next;
            
            // Always increment ones digit
            ones <= (ones_max) ? 4'd0 : (ones + 4'd1);
            
            // Conditional increment for higher digits
            tens <= (ena_reg[0]) ? ((tens_max) ? 4'd0 : (tens + 4'd1)) : tens;
            hundreds <= (ena_reg[1]) ? ((hundreds_max) ? 4'd0 : (hundreds + 4'd1)) : hundreds;
            thousands <= (ena_reg[2]) ? ((thousands == 4'd9) ? 4'd0 : (thousands + 4'd1)) : thousands;
        end
    end

endmodule