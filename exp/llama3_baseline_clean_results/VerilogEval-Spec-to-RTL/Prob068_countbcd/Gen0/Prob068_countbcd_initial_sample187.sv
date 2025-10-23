module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones, tens, hundreds, thousands;
reg [2:0] ena_reg;

always @(posedge clk) begin
    if (reset) begin
        ones <= 0;
        tens <= 0;
        hundreds <= 0;
        thousands <= 0;
    end else begin
        ena_reg <= 0;
        // Increment ones counter
        if (ones == 9) begin
            ones <= 0;
            ena_reg[0] <= 1; // Enable tens digit to increment
        end else begin
            ones <= ones + 1;
        end
        
        // Increment tens counter
        if (ena_reg[0] && tens == 9) begin
            tens <= 0;
            ena_reg[1] <= 1; // Enable hundreds digit to increment
        end else if (ena_reg[0]) begin
            tens <= tens + 1;
        end
        
        // Increment hundreds counter
        if (ena_reg[1] && hundreds == 9) begin
            hundreds <= 0;
            ena_reg[2] <= 1; // Enable thousands digit to increment
        end else if (ena_reg[1]) begin
            hundreds <= hundreds + 1;
        end
        
        // Increment thousands counter
        if (ena_reg[2] && thousands == 9) begin
            thousands <= 0;
        end else if (ena_reg[2]) begin
            thousands <= thousands + 1;
        end
    end
end

assign ena = ena_reg;
assign q = {thousands, hundreds, tens, ones};

endmodule