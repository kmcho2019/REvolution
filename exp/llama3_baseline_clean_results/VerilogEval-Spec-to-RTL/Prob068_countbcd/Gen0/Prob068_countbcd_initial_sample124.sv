module TopModule(
    input  clk,
    input  reset,
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
        ena_reg <= 0;
    end else begin
        // Enable signals
        ena_reg[0] <= (ones == 4'd9);
        ena_reg[1] <= (tens == 4'd9) && (ones == 4'd9);
        ena_reg[2] <= (hundreds == 4'd9) && (tens == 4'd9) && (ones == 4'd9);
        
        // Counters
        if (ena_reg[0]) begin
            tens <= tens + 1;
            ones <= 0;
        end else begin
            if (ones == 4'd9) begin
                ones <= 0;
            end else begin
                ones <= ones + 1;
            end
        end
        
        if (ena_reg[1]) begin
            hundreds <= hundreds + 1;
            tens <= 0;
        end
        
        if (ena_reg[2]) begin
            thousands <= thousands + 1;
            hundreds <= 0;
        end
        
        // Carry for thousands digit
        if (thousands == 4'd9 && hundreds == 4'd9 && tens == 4'd9 && ones == 4'd9) begin
            thousands <= 0;
            hundreds <= 0;
            tens <= 0;
            ones <= 0;
        end
    end
end

assign ena = ena_reg;
assign q = {thousands, hundreds, tens, ones};

endmodule