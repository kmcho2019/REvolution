module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    reg [3:0] hundreds; // 0 to 9
    reg [3:0] tens;     // 0 to 9
    reg [3:0] units;    // 0 to 9

    wire units_wrap = (units == 4'd9);
    wire tens_wrap = (tens == 4'd9);
    wire hundreds_wrap = (hundreds == 4'd9);

    // Next state logic for units, tens, hundreds
    wire [3:0] next_units = units_wrap ? 4'd0 : (units + 4'd1);
    wire [3:0] next_tens = (units_wrap) ? ((tens_wrap) ? 4'd0 : (tens + 4'd1)) : tens;
    wire [3:0] next_hundreds = (units_wrap & tens_wrap) ? ((hundreds_wrap) ? 4'd0 : (hundreds + 4'd1)) : hundreds;

    // Compute q as hundreds*100 + tens*10 + units
    wire [9:0] combined_count = (hundreds * 10'd100) + (tens * 10'd10) + units;

    always @(posedge clk) begin
        if (reset) begin
            hundreds <= 4'd0;
            tens <= 4'd0;
            units <= 4'd0;
            q <= 10'd0;
        end else begin
            hundreds <= next_hundreds;
            tens <= next_tens;
            units <= next_units;
            q <= combined_count;
        end
    end

endmodule