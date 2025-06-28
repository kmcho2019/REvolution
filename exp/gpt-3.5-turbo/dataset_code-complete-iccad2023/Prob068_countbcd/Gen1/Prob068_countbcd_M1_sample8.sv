module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

reg [13:0] counter = 14'b0000;
reg [1:0] bcd_digit; // Indicates which BCD digit is currently being updated

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 14'b0000;
        bcd_digit <= 2'b00;
    end else begin
        // Increment counter on every clock cycle
        counter <= (counter == 14'b1001_1001_1001_1001) ? 14'b0000 : counter + 1;
        
        // Decode the counter value to obtain BCD digits
        case (bcd_digit)
            2'b00: q[3:0] <= counter[3:0]; // Ones digit
            2'b01: q[7:4] <= counter[7:4]; // Tens digit
            2'b10: q[11:8] <= counter[11:8]; // Hundreds digit
            2'b11: q[15:12] <= counter[15:12]; // Thousands digit
        endcase
        
        // Update which BCD digit is currently being updated
        if (counter == 14'b1001_1001_1001_1000)
            bcd_digit <= 2'b01; // Update tens digit
        else if (counter == 14'b1001_1001_1000_1001)
            bcd_digit <= 2'b10; // Update hundreds digit
        else if (counter == 14'b1001_1000_1001_1001)
            bcd_digit <= 2'b11; // Update thousands digit
        
        // Generate enable signals for tens, hundreds, and thousands digits
        ena[1] <= (counter >= 5000); // Tens digit enabled above 4999
        ena[2] <= (counter >= 9000); // Hundreds digit enabled above 8999
        ena[3] <= (counter >= 9900); // Thousands digit enabled above 9999
    end
end

endmodule