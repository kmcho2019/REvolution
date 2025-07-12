module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones, tens, hundreds, thousands;
reg [2:0] ena_reg;
reg [15:0] q_reg;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        ones <= 4'b0;
        tens <= 4'b0;
        hundreds <= 4'b0;
        thousands <= 4'b0;
        ena_reg <= 3'b0;
    end else begin
        // Increment the ones digit
        ones <= ones + 1;
        
        // Check if the ones digit has wrapped around to zero
        if (ones == 4'b10000) begin
            ones <= 4'b0;
            
            // Increment the tens digit and assert enable signal
            tens <= tens + 1;
            ena_reg[0] <= 1'b1;
        end else begin
            ena_reg[0] <= 1'b0;
        end
        
        // Check if the tens digit has wrapped around to zero
        if (tens == 4'b10000) begin
            tens <= 4'b0;
            
            // Increment the hundreds digit and assert enable signal
            hundreds <= hundreds + 1;
            ena_reg[1] <= 1'b1;
        end else begin
            ena_reg[1] <= 1'b0;
        end
        
        // Check if the hundreds digit has wrapped around to zero
        if (hundreds == 4'b10000) begin
            hundreds <= 4'b0;
            
            // Increment the thousands digit and assert enable signal
            thousands <= thousands + 1;
            ena_reg[2] <= 1'b1;
        end else begin
            ena_reg[2] <= 1'b0;
        end
    end
end

assign ena = ena_reg;
assign q = {thousands, hundreds, tens, ones};

endmodule