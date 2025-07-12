module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones, tens, hundreds, thousands;
reg [2:0] ena_reg;

// Set default values
initial begin
    ones = 4'b0000;
    tens = 4'b0000;
    hundreds = 4'b0000;
    thousands = 4'b0000;
    ena_reg = 3'b000;
end

always @ (posedge clk or posedge reset) begin
    if(reset) begin
        ones <= 4'b0000;
        tens <= 4'b0000;
        hundreds <= 4'b0000;
        thousands <= 4'b0000;
        ena_reg <= 3'b000;
    end else begin
        // Determine enable signals
        if(ones == 4'b1001) begin
            ena_reg[0] <= 1'b1;
        end else begin
            ena_reg[0] <= 1'b0;
        end
        
        if((ones == 4'b1001) && (tens == 4'b1001)) begin
            ena_reg[1] <= 1'b1;
        end else begin
            ena_reg[1] <= 1'b0;
        end
        
        if((ones == 4'b1001) && (tens == 4'b1001) && (hundreds == 4'b1001)) begin
            ena_reg[2] <= 1'b1;
        end else begin
            ena_reg[2] <= 1'b0;
        end
        
        // Update counter values
        if(ones != 4'b1001) begin
            ones <= ones + 1;
        end else begin
            ones <= 4'b0000;
        end
        
        if(ena_reg[0] && (tens != 4'b1001)) begin
            tens <= tens + 1;
        end else if(ena_reg[0] && (tens == 4'b1001)) begin
            tens <= 4'b0000;
        end
        
        if(ena_reg[1] && (hundreds != 4'b1001)) begin
            hundreds <= hundreds + 1;
        end else if(ena_reg[1] && (hundreds == 4'b1001)) begin
            hundreds <= 4'b0000;
        end
        
        if(ena_reg[2] && (thousands != 4'b1001)) begin
            thousands <= thousands + 1;
        end else if(ena_reg[2] && (thousands == 4'b1001)) begin
            thousands <= 4'b0000;
        end
    end
end

// Assign output signals
assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;
assign ena = ena_reg;

endmodule