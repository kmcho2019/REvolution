module BCD_Digit_Shared (
    input clk,
    input reset,
    input en,
    output reg [3:0] value,
    output reg rollover
);

    always @(posedge clk) begin
        if (reset) begin
            value <= 4'd0;
            rollover <= 1'b0;
        end else if (en) begin
            if (value == 4'd9) begin
                value <= 4'd0;
                rollover <= 1'b1;
            end else begin
                value <= value + 4'd1;
                rollover <= 1'b0;
            end
        end else begin
            rollover <= 1'b0;
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
    wire rollover_ones, rollover_tens, rollover_hundreds;
    wire ones_enable;
    
    // Actual clock gating implementation
    assign ones_enable = 1'b1;  // Replace with actual gating condition if available
    
    // Shared rollover detection with parallel enable generation
    BCD_Digit_Shared ones_digit (
        .clk(clk),
        .reset(reset),
        .en(ones_enable),
        .value(ones),
        .rollover(rollover_ones)
    );
    
    BCD_Digit_Shared tens_digit (
        .clk(clk),
        .reset(reset),
        .en(rollover_ones),
        .value(tens),
        .rollover(rollover_tens)
    );
    
    BCD_Digit_Shared hundreds_digit (
        .clk(clk),
        .reset(reset),
        .en(rollover_tens),
        .value(hundreds),
        .rollover(rollover_hundreds)
    );
    
    // Thousands digit doesn't need rollover detection
    BCD_Digit_Shared thousands_digit (
        .clk(clk),
        .reset(reset),
        .en(rollover_hundreds),
        .value(thousands),
        .rollover()
    );
    
    // Parallel enable outputs
    assign ena[0] = rollover_ones;
    assign ena[1] = rollover_tens;
    assign ena[2] = rollover_hundreds;
    
    // Output concatenation
    assign q = {thousands, hundreds, tens, ones};

endmodule