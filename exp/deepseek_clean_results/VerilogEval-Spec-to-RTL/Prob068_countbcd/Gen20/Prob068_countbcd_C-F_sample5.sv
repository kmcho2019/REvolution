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
    wire ones_max, tens_max, hundreds_max;
    
    // Current digit values
    assign ones_max = (ones == 4'd9);
    assign tens_max = (tens == 4'd9);
    assign hundreds_max = (hundreds == 4'd9);
    
    // Parallel enable generation
    assign ena[0] = ones_max;                          // Tens enable
    assign ena[1] = ones_max & tens_max;               // Hundreds enable
    assign ena[2] = ones_max & tens_max & hundreds_max;// Thousands enable
    
    // Instantiate digit modules
    BCD_Digit ones_digit (
        .clk(clk),
        .reset(reset),
        .en(1'b1),          // Always count ones
        .value(ones)
    );
    
    BCD_Digit tens_digit (
        .clk(clk),
        .reset(reset),
        .en(ena[0]),        // Enabled when ones overflow
        .value(tens)
    );
    
    BCD_Digit hundreds_digit (
        .clk(clk),
        .reset(reset),
        .en(ena[1]),        // Enabled when tens overflow
        .value(hundreds)
    );
    
    BCD_Digit thousands_digit (
        .clk(clk),
        .reset(reset),
        .en(ena[2]),        // Enabled when hundreds overflow
        .value(thousands)
    );
    
    // Concatenate final output
    assign q = {thousands, hundreds, tens, ones};

endmodule