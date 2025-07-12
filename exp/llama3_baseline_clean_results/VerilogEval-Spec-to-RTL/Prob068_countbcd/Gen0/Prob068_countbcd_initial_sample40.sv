module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

// Initialize variables to store the BCD digits
reg [3:0] ones;
reg [3:0] tens;
reg [3:0] hundreds;
reg [3:0] thousands;

// Initialize enable signals for the upper three digits
reg ena_ones_to_tens;
reg ena_tens_to_hundreds;
reg ena_hundreds_to_thousands;

// Generate enable signals
assign ena = {ena_hundreds_to_thousands, ena_tens_to_hundreds, ena_ones_to_tens};
assign ena_ones_to_tens = (ones == 4'd9)? 1'b1 : 1'b0;
assign ena_tens_to_hundreds = (tens == 4'd9 && ena_ones_to_tens)? 1'b1 : 1'b0;
assign ena_hundreds_to_thousands = (hundreds == 4'd9 && ena_tens_to_hundreds && ena_ones_to_tens)? 1'b1 : 1'b0;

// Concatenate the BCD digits
assign q = {thousands, hundreds, tens, ones};

// Sequential logic for the BCD counter
always @(posedge clk) begin
    if (reset) begin
        // Reset all counters to zero
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        // Increment the ones digit
        if (ones == 4'd9) begin
            ones <= 4'd0;
            if (ena_ones_to_tens) begin
                // Increment the tens digit
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    if (ena_tens_to_hundreds) begin
                        // Increment the hundreds digit
                        if (hundreds == 4'd9) begin
                            hundreds <= 4'd0;
                            if (ena_hundreds_to_thousands) begin
                                // Increment the thousands digit
                                if (thousands == 4'd9) begin
                                    thousands <= 4'd0;
                                end else begin
                                    thousands <= thousands + 1;
                                end
                            end else begin
                                thousands <= thousands;
                            end
                        end else begin
                            hundreds <= hundreds + 1;
                        end
                    end else begin
                        hundreds <= hundreds;
                    end
                end else begin
                    tens <= tens + 1;
                end
            end else begin
                tens <= tens;
            end
        end else begin
            ones <= ones + 1;
        end
    end
end

endmodule