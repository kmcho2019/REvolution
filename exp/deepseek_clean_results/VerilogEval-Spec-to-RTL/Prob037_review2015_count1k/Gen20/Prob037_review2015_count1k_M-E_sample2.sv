module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] units;  // 0-9
reg [3:0] tens;   // 0-9
reg [3:0] hundreds; // 0-9

wire units_max = (units == 4'd9);
wire tens_max = (tens == 4'd9);
wire hundreds_max = (hundreds == 4'd9);

wire [9:0] bcd_to_binary = hundreds * 7'd100 + tens * 7'd10 + units;

assign q = bcd_to_binary;

always @(posedge clk) begin
    if (reset) begin
        units <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
    end
    else begin
        // Units digit increments every cycle
        units <= units_max ? 4'd0 : units + 4'd1;
        
        // Tens digit increments when units rolls over
        if (units_max) begin
            tens <= tens_max ? 4'd0 : tens + 4'd1;
        end
        
        // Hundreds digit increments when tens and units roll over
        if (units_max && tens_max) begin
            hundreds <= hundreds_max ? 4'd0 : hundreds + 4'd1;
        end
    end
end

endmodule