module BCD_Digit_Optimized (
    input clk,
    input reset,
    input en,
    input lower_digit_max,
    output reg [3:0] value,
    output reg next_en
);

    // Internal signals
    wire digit_max = (value == 4'd9);
    wire increment = en & lower_digit_max;
    
    // Clock gating
    wire digit_clk = clk & (reset | increment);

    always @(posedge digit_clk) begin
        if (reset) begin
            value <= 4'd0;
            next_en <= 1'b0;
        end else if (increment) begin
            value <= (digit_max) ? 4'd0 : value + 4'd1;
            next_en <= digit_max;
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
    wire ones_next_en, tens_next_en, hundreds_next_en;
    
    // Digit values
    assign q = {thousands, hundreds, tens, ones};
    
    // Enable outputs
    assign ena[0] = ones_next_en;
    assign ena[1] = tens_next_en;
    assign ena[2] = hundreds_next_en;
    
    // Ones digit (always enabled)
    BCD_Digit_Optimized ones_digit (
        .clk(clk),
        .reset(reset),
        .en(1'b1),
        .lower_digit_max(1'b1),
        .value(ones),
        .next_en(ones_next_en)
    );
    
    // Tens digit
    BCD_Digit_Optimized tens_digit (
        .clk(clk),
        .reset(reset),
        .en(ones_next_en),
        .lower_digit_max(1'b1),  // Only needs enable from ones
        .value(tens),
        .next_en(tens_next_en)
    );
    
    // Hundreds digit
    BCD_Digit_Optimized hundreds_digit (
        .clk(clk),
        .reset(reset),
        .en(tens_next_en),
        .lower_digit_max(1'b1),  // Only needs enable from tens
        .value(hundreds),
        .next_en(hundreds_next_en)
    );
    
    // Thousands digit (simplified without enable outputs)
    reg [3:0] thousands_reg;
    wire thousands_clk = clk & (reset | (hundreds_next_en));
    
    always @(posedge thousands_clk) begin
        if (reset) begin
            thousands_reg <= 4'd0;
        end else if (hundreds_next_en) begin
            thousands_reg <= (thousands_reg == 4'd9) ? 4'd0 : thousands_reg + 4'd1;
        end
    end
    
    assign thousands = thousands_reg;

endmodule