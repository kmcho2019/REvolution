module BCD_Digit (
    input clk,
    input reset,
    input en,
    output reg [3:0] value,
    output digit_max
);

    assign digit_max = (value == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            value <= 4'd0;
        end else if (en) begin
            value <= digit_max ? 4'd0 : value + 4'd1;
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
    wire ones_max, tens_max, hundreds_max;
    
    // Digit values
    assign q = {thousands, hundreds, tens, ones};
    
    // Shared comparison logic for enable signals
    wire ones_at_max = (ones == 4'd9);
    wire tens_at_max = (tens == 4'd9);
    wire hundreds_at_max = (hundreds == 4'd9);
    
    // Parallel enable generation
    assign ena[0] = ones_at_max;
    assign ena[1] = ones_at_max & tens_at_max;
    assign ena[2] = ones_at_max & tens_at_max & hundreds_at_max;
    
    // Instantiate digits with appropriate enable signals
    BCD_Digit ones_digit (
        .clk(clk),
        .reset(reset),
        .en(1'b1),      // Always enabled
        .value(ones),
        .digit_max(ones_max)
    );
    
    BCD_Digit tens_digit (
        .clk(clk),
        .reset(reset),
        .en(ena[0]),    // Enabled when ones overflows
        .value(tens),
        .digit_max(tens_max)
    );
    
    BCD_Digit hundreds_digit (
        .clk(clk),
        .reset(reset),
        .en(ena[1]),    // Enabled when tens overflows
        .value(hundreds),
        .digit_max(hundreds_max)
    );
    
    BCD_Digit thousands_digit (
        .clk(clk),
        .reset(reset),
        .en(ena[2]),    // Enabled when hundreds overflows
        .value(thousands),
        .digit_max()    // Not used
    );

endmodule