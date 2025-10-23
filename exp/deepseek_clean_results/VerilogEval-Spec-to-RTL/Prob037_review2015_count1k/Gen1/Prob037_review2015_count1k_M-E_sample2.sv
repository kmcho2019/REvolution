module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] units = 4'b0;
reg [3:0] tens = 4'b0;
reg [3:0] hundreds = 4'b0;

wire units_rollover = (units == 4'd9);
wire tens_rollover = (tens == 4'd9);
wire all_nines = (units == 4'd9) && (tens == 4'd9) && (hundreds == 4'd9);

always @(posedge clk) begin
    if (reset) begin
        units <= 4'b0;
        tens <= 4'b0;
        hundreds <= 4'b0;
    end
    else begin
        // Units digit counter
        if (units_rollover)
            units <= 4'b0;
        else
            units <= units + 1'b1;
            
        // Tens digit counter (increments when units rolls over)
        if (units_rollover) begin
            if (tens_rollover)
                tens <= 4'b0;
            else
                tens <= tens + 1'b1;
        end
        
        // Hundreds digit counter (increments when tens rolls over)
        if (units_rollover && tens_rollover) begin
            if (all_nines)
                hundreds <= 4'b0;
            else
                hundreds <= hundreds + 1'b1;
        end
    end
end

// Combine the digits to form the 10-bit output
assign q = {hundreds, tens, units};

endmodule