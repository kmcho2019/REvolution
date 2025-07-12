module BCD_Digit_Optimized (
    input clk,
    input reset,
    input en,
    input lower_digit_max,  // Indicates lower digit is at max value
    output reg [3:0] value,
    output digit_max,       // Indicates this digit is at max value
    output next_en         // Enable for next higher digit
);

    // Current digit is at max value (9)
    assign digit_max = (value == 4'd9);
    
    // Next enable is combination of current enable and digit_max
    assign next_en = en & digit_max;
    
    always @(posedge clk) begin
        if (reset) begin
            value <= 4'd0;
        end else if (en & lower_digit_max) begin
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
    wire ones_max, tens_max, hundreds_max;
    wire ones_next_en, tens_next_en, hundreds_next_en;
    
    // Clock gating signals
    wire tens_clk_en = ones_next_en;
    wire hundreds_clk_en = tens_next_en;
    wire thousands_clk_en = hundreds_next_en;
    
    // Gated clocks
    wire tens_clk = tens_clk_en & clk;
    wire hundreds_clk = hundreds_clk_en & clk;
    wire thousands_clk = thousands_clk_en & clk;
    
    // Digit values
    assign q = {thousands, hundreds, tens, ones};
    
    // Enable outputs for verification
    assign ena[0] = ones_next_en;
    assign ena[1] = tens_next_en;
    assign ena[2] = hundreds_next_en;
    
    // Ones digit (always enabled, no lower digit)
    BCD_Digit_Optimized ones_digit (
        .clk(clk),
        .reset(reset),
        .en(1'b1),
        .lower_digit_max(1'b1),  // Always true for ones digit
        .value(ones),
        .digit_max(ones_max),
        .next_en(ones_next_en)
    );
    
    // Tens digit (enabled by ones digit)
    BCD_Digit_Optimized tens_digit (
        .clk(tens_clk),          // Gated clock
        .reset(reset),
        .en(1'b1),               // Always enabled when clock is active
        .lower_digit_max(ones_max),
        .value(tens),
        .digit_max(tens_max),
        .next_en(tens_next_en)
    );
    
    // Hundreds digit (enabled by tens digit)
    BCD_Digit_Optimized hundreds_digit (
        .clk(hundreds_clk),      // Gated clock
        .reset(reset),
        .en(1'b1),               // Always enabled when clock is active
        .lower_digit_max(tens_max),
        .value(hundreds),
        .digit_max(hundreds_max),
        .next_en(hundreds_next_en)
    );
    
    // Thousands digit (enabled by hundreds digit)
    BCD_Digit_Optimized thousands_digit (
        .clk(thousands_clk),     // Gated clock
        .reset(reset),
        .en(1'b1),               // Always enabled when clock is active
        .lower_digit_max(hundreds_max),
        .value(thousands),
        .digit_max(),            // Not used
        .next_en()               // Not used
    );

endmodule