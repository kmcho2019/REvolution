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
    
    // Instantiate digit modules with direct enable outputs
    BCD_Digit ones_digit (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
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
    
    BCD_Digit thousands_digit (
        .clk(clk),
        .reset(reset),
        .enable(ena[2]),
        .value(thousands),
        .en_out()  // No higher digit to enable
    );
    
    // Concatenate outputs cleanly
    assign q = {thousands, hundreds, tens, ones};

endmodule