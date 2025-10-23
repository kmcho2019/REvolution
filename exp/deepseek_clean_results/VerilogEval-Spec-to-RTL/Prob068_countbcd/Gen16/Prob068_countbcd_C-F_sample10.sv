module BCD_Digit_Optimized (
    input clk,
    input reset,
    input enable,
    output reg [3:0] value,
    output rollover
);

    // Shared comparator for rollover detection
    always @(posedge clk) begin
        if (reset) begin
            value <= 4'd0;
        end else if (enable) begin
            value <= (value == 4'd9) ? 4'd0 : value + 4'd1;
        end
    end

    assign rollover = (value == 4'd9) & enable;

endmodule

module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    wire [3:0] ones, tens, hundreds, thousands;
    wire rollover_ones, rollover_tens, rollover_hundreds;
    wire ones_enable;
    
    // Clock gating for power optimization
    assign ones_enable = 1'b1;  // Could be replaced with actual gating logic
    
    // Instantiate optimized digit modules
    BCD_Digit_Optimized ones_digit (
        .clk(clk),
        .reset(reset),
        .enable(ones_enable),
        .value(ones),
        .rollover(rollover_ones)
    );
    
    BCD_Digit_Optimized tens_digit (
        .clk(clk),
        .reset(reset),
        .enable(rollover_ones),
        .value(tens),
        .rollover(rollover_tens)
    );
    
    BCD_Digit_Optimized hundreds_digit (
        .clk(clk),
        .reset(reset),
        .enable(rollover_tens),
        .value(hundreds),
        .rollover(rollover_hundreds)
    );
    
    BCD_Digit_Optimized thousands_digit (
        .clk(clk),
        .reset(reset),
        .enable(rollover_hundreds),
        .value(thousands),
        .rollover()  // Not used
    );
    
    // Simplified enable outputs
    assign ena = {rollover_hundreds, rollover_tens, rollover_ones};
    assign q = {thousands, hundreds, tens, ones};

endmodule