module BCD_Digit (
    input clk,
    input reset,
    input en,
    output reg [3:0] value,
    output reg carry_out
);

    always @(posedge clk) begin
        if (reset) begin
            value <= 4'd0;
            carry_out <= 1'b0;
        end else if (en) begin
            if (value == 4'd9) begin
                value <= 4'd0;
                carry_out <= 1'b1;
            end else begin
                value <= value + 4'd1;
                carry_out <= 1'b0;
            end
        end else begin
            carry_out <= 1'b0;
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
    wire ones_carry, tens_carry, hundreds_carry;
    reg [2:0] ena_reg;
    
    // Pipeline stage for enable signals
    always @(posedge clk) begin
        if (reset) begin
            ena_reg <= 3'b0;
        end else begin
            ena_reg[0] <= ones_carry;
            ena_reg[1] <= ones_carry & tens_carry;
            ena_reg[2] <= ones_carry & tens_carry & hundreds_carry;
        end
    end
    
    assign ena = ena_reg;
    assign q = {thousands, hundreds, tens, ones};
    
    // Instantiate digits with carry signals
    BCD_Digit ones_digit (
        .clk(clk),
        .reset(reset),
        .en(1'b1),
        .value(ones),
        .carry_out(ones_carry)
    );
    
    BCD_Digit tens_digit (
        .clk(clk),
        .reset(reset),
        .en(ena_reg[0]),
        .value(tens),
        .carry_out(tens_carry)
    );
    
    BCD_Digit hundreds_digit (
        .clk(clk),
        .reset(reset),
        .en(ena_reg[1]),
        .value(hundreds),
        .carry_out(hundreds_carry)
    );
    
    BCD_Digit thousands_digit (
        .clk(clk),
        .reset(reset),
        .en(ena_reg[2]),
        .value(thousands),
        .carry_out()  // Not used
    );

endmodule