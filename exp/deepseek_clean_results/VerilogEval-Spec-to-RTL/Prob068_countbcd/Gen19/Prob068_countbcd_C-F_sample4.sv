module BCD_Digit (
    input clk,
    input reset,
    input enable,
    output reg [3:0] value,
    output en_out
);

    wire digit_max = (value == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            value <= 4'd0;
        end else if (enable) begin
            value <= digit_max ? 4'd0 : value + 4'd1;
        end
    end

    assign en_out = digit_max & enable;

endmodule

module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    wire [3:0] ones, tens, hundreds, thousands;
    wire ones_max, tens_max, hundreds_max;
    
    // Instantiate digit modules with optimized enable outputs
    BCD_Digit ones_digit (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .value(ones),
        .en_out(ones_max)
    );
    
    BCD_Digit tens_digit (
        .clk(clk),
        .reset(reset),
        .enable(ones_max),
        .value(tens),
        .en_out(tens_max)
    );
    
    BCD_Digit hundreds_digit (
        .clk(clk),
        .reset(reset),
        .enable(tens_max),
        .value(hundreds),
        .en_out(hundreds_max)
    );
    
    BCD_Digit thousands_digit (
        .clk(clk),
        .reset(reset),
        .enable(hundreds_max),
        .value(thousands),
        .en_out()  // Not connected to save power/area
    );
    
    // Generate enable outputs for upper digits
    assign ena[0] = ones_max;
    assign ena[1] = tens_max;
    assign ena[2] = hundreds_max;
    
    // Concatenate outputs
    assign q = {thousands, hundreds, tens, ones};

endmodule