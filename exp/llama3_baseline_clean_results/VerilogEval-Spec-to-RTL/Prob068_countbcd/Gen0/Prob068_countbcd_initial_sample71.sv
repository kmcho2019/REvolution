module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [15:0] q_reg;  // register to hold the current count
reg [2:0] ena_reg;  // register to hold the enable signals

always @(posedge clk or posedge reset) begin
    if (reset) begin  // if reset is high, reset the counter
        q_reg <= 0;
        ena_reg <= 0;
    end else begin  // if reset is low, increment the counter
        reg [3:0] ones, tens, hundreds, thousands;  // wires to hold the current digits
        reg [3:0] ones_next, tens_next, hundreds_next, thousands_next;  // wires to hold the next digits
        
        // assign the current digits
        ones = q_reg[3:0];
        tens = q_reg[7:4];
        hundreds = q_reg[11:8];
        thousands = q_reg[15:12];
        
        // increment the ones digit
        if (ones == 4'd9) begin
            ones_next = 0;
            ena_reg[0] = 1'b1;  // enable the tens digit
        end else begin
            ones_next = ones + 1'b1;
            ena_reg[0] = 1'b0;  // disable the tens digit
        end
        
        // increment the tens digit
        if (tens == 4'd9 && ena_reg[0] == 1'b1) begin
            tens_next = 0;
            ena_reg[1] = 1'b1;  // enable the hundreds digit
        end else if (ena_reg[0] == 1'b1) begin
            tens_next = tens + 1'b1;
            ena_reg[1] = 1'b0;  // disable the hundreds digit
        end else begin
            tens_next = tens;
            ena_reg[1] = 1'b0;  // disable the hundreds digit
        end
        
        // increment the hundreds digit
        if (hundreds == 4'd9 && ena_reg[1] == 1'b1) begin
            hundreds_next = 0;
            ena_reg[2] = 1'b1;  // enable the thousands digit
        end else if (ena_reg[1] == 1'b1) begin
            hundreds_next = hundreds + 1'b1;
            ena_reg[2] = 1'b0;  // disable the thousands digit
        end else begin
            hundreds_next = hundreds;
            ena_reg[2] = 1'b0;  // disable the thousands digit
        end
        
        // increment the thousands digit
        if (thousands == 4'd9 && ena_reg[2] == 1'b1) begin
            thousands_next = 0;
        end else if (ena_reg[2] == 1'b1) begin
            thousands_next = thousands + 1'b1;
        end else begin
            thousands_next = thousands;
        end
        
        // assign the next digits to the register
        q_reg <= {thousands_next, hundreds_next, tens_next, ones_next};
    end
end

// assign the register values to the output ports
assign ena = ena_reg;
assign q = q_reg;

endmodule