module BCD_Digit (
    input clk,
    input reset,
    input enable,
    output reg [3:0] value,
    output en_out
);

    always @(posedge clk) begin
        if (reset) begin
            value <= 4'd0;
        end else if (enable) begin
            value <= (value == 4'd9) ? 4'd0 : value + 4'd1;
        end
    end

    assign en_out = (value == 4'd9) & enable;

endmodule

module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    wire [3:0] ones, tens, hundreds, thousands;
    wire ones_enable;
    
    // Actual clock gating implementation
    // Enable ones digit only when counting is needed
    // (This could be controlled by external logic if needed)
    assign ones_enable = 1'b1;  // Replace with actual gating logic
    
    // Instantiate digit modules with direct enable outputs
    BCD_Digit ones_digit (
        .clk(clk),
        .reset(reset),
        .enable(ones_enable),
        .value(ones),
        .en_out(ena[0])
    );
    
    BCD_Digit tens_digit (
        .clk(clk),
        .reset(reset),
        .enable(ena[0]),
        .value(tens),
        .en_out(ena[1])
    );
    
    BCD_Digit hundreds_digit (
        .clk(clk),
        .reset(reset),
        .enable(ena[1]),
        .value(hundreds),
        .en_out(ena[2])
    );
    
    // Thousands digit - no rollover output needed
    BCD_Digit thousands_digit (
        .clk(clk),
        .reset(reset),
        .enable(ena[2]),
        .value(thousands),
        .en_out()  // No output needed
    );
    
    // Concatenate outputs
    assign q = {thousands, hundreds, tens, ones};

endmodule