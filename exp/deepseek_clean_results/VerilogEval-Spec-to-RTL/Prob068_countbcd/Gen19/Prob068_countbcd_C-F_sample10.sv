module BCD_Digit #(
    parameter HAS_EN_OUT = 1  // Enable output generation
)(
    input clk,
    input reset,
    input en_in,
    output reg [3:0] value,
    output en_out
);

    // Counter logic
    always @(posedge clk) begin
        if (reset) begin
            value <= 4'd0;
        end else if (en_in) begin
            value <= (value == 4'd9) ? 4'd0 : value + 4'd1;
        end
    end

    // Conditional enable output generation
    generate if (HAS_EN_OUT) begin
        assign en_out = (value == 4'd9) & en_in;
    end else begin
        assign en_out = 1'b0;  // Tie-off when not used
    end endgenerate

endmodule

module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    wire [3:0] ones, tens, hundreds, thousands;
    wire en_tens, en_hundreds, en_thousands;
    
    // Ones digit (always enabled, no reset needed)
    BCD_Digit #(.HAS_EN_OUT(1)) ones_digit (
        .clk(clk),
        .reset(reset),
        .en_in(1'b1),
        .value(ones),
        .en_out(en_tens)
    );
    
    // Tens digit
    BCD_Digit #(.HAS_EN_OUT(1)) tens_digit (
        .clk(clk),
        .reset(reset),
        .en_in(en_tens),
        .value(tens),
        .en_out(en_hundreds)
    );
    
    // Hundreds digit
    BCD_Digit #(.HAS_EN_OUT(1)) hundreds_digit (
        .clk(clk),
        .reset(reset),
        .en_in(en_hundreds),
        .value(hundreds),
        .en_out(en_thousands)
    );
    
    // Thousands digit (no enable output needed)
    BCD_Digit #(.HAS_EN_OUT(0)) thousands_digit (
        .clk(clk),
        .reset(reset),
        .en_in(en_thousands),
        .value(thousands),
        .en_out()  // No output needed
    );
    
    // Output assignments
    assign q = {thousands, hundreds, tens, ones};
    assign ena = {en_thousands, en_hundreds, en_tens};

endmodule