module BCD_Digit_With_Enable (
    input clk,
    input reset,
    input en_in,            // Enable from lower digit
    output reg [3:0] value, // Current digit value
    output en_out           // Enable for next higher digit
);

    // Internal enable signal
    wire digit_en = en_in && (value == 4'd9);

    // Digit counter
    always @(posedge clk) begin
        if (reset) begin
            value <= 4'd0;
        end else if (en_in) begin
            value <= (value == 4'd9) ? 4'd0 : value + 4'd1;
        end
    end

    // Enable output for next digit
    assign en_out = digit_en;

endmodule

module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    wire [3:0] ones, tens, hundreds, thousands;
    wire en_tens, en_hundreds, en_thousands;
    
    // Digit values
    assign q = {thousands, hundreds, tens, ones};
    
    // Enable outputs for observation
    assign ena = {en_thousands, en_hundreds, en_tens};
    
    // Ones digit (always enabled)
    BCD_Digit_With_Enable ones_digit (
        .clk(clk),
        .reset(reset),
        .en_in(1'b1),
        .value(ones),
        .en_out(en_tens)
    );
    
    // Tens digit
    BCD_Digit_With_Enable tens_digit (
        .clk(clk),
        .reset(reset),
        .en_in(en_tens),
        .value(tens),
        .en_out(en_hundreds)
    );
    
    // Hundreds digit
    BCD_Digit_With_Enable hundreds_digit (
        .clk(clk),
        .reset(reset),
        .en_in(en_hundreds),
        .value(hundreds),
        .en_out(en_thousands)
    );
    
    // Thousands digit
    BCD_Digit_With_Enable thousands_digit (
        .clk(clk),
        .reset(reset),
        .en_in(en_thousands),
        .value(thousands),
        .en_out()  // No higher digit to enable
    );

endmodule