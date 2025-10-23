module BCD_Digit (
    input clk,
    input reset,
    input en,
    output reg [3:0] value
);

    always @(posedge clk) begin
        if (reset) begin
            value <= 4'd0;
        end else if (en) begin
            value <= (value == 4'd9) ? 4'd0 : value + 4'd1;
        end
    end

endmodule

module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    wire [3:0] ones, tens, hundreds, thousands;
    
    // Digit values
    assign q = {thousands, hundreds, tens, ones};
    
    // Enable logic - parallel computation avoids ripple delay
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (ones == 4'd9) && (tens == 4'd9);
    assign ena[2] = (ones == 4'd9) && (tens == 4'd9) && (hundreds == 4'd9);
    
    // Instantiate digits with appropriate enable signals
    BCD_Digit ones_digit (
        .clk(clk),
        .reset(reset),
        .en(1'b1),      // Always enabled
        .value(ones)
    );
    
    BCD_Digit tens_digit (
        .clk(clk),
        .reset(reset),
        .en(ena[0]),    // Enabled when ones overflows
        .value(tens)
    );
    
    BCD_Digit hundreds_digit (
        .clk(clk),
        .reset(reset),
        .en(ena[1]),    // Enabled when tens overflows
        .value(hundreds)
    );
    
    BCD_Digit thousands_digit (
        .clk(clk),
        .reset(reset),
        .en(ena[2]),    // Enabled when hundreds overflows
        .value(thousands)
    );

endmodule