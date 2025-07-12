module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

reg [3:0] units;  // 0-9
reg [3:0] tens;   // 0-9
reg [3:0] hundreds; // 0-9

wire units_tc = (units == 4'd9);
wire tens_tc = (tens == 4'd9);
wire all_tc = units_tc & tens_tc & (hundreds == 4'd9);

always @(posedge clk) begin
    if (reset) begin
        units <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
    end
    else begin
        // Units digit increments every cycle
        units <= units_tc ? 4'd0 : units + 4'd1;
        
        // Tens digit increments when units rolls over
        tens <= units_tc ? (tens_tc ? 4'd0 : tens + 4'd1) : tens;
        
        // Hundreds digit increments when tens rolls over
        hundreds <= (units_tc & tens_tc) ? 
                   (all_tc ? 4'd0 : hundreds + 4'd1) : hundreds;
    end
end

// Combine BCD digits into 10-bit binary output
always @(*) begin
    q = hundreds * 10'd100 + tens * 10'd10 + units;
end

endmodule