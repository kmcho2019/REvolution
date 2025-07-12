module BCD_Digit (
    input clk,
    input reset,
    input en,
    output reg [3:0] value,
    output reg en_out
);

    always @(posedge clk) begin
        if (reset) begin
            value <= 4'd0;
            en_out <= 1'b0;
        end else if (en) begin
            if (value == 4'd9) begin
                value <= 4'd0;
                en_out <= 1'b1;
            end else begin
                value <= value + 4'd1;
                en_out <= 1'b0;
            end
        end else begin
            en_out <= 1'b0;
        end
    end

endmodule

module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    wire ones_overflow, tens_overflow, hundreds_overflow;
    reg [2:0] ena_reg;
    
    // Instantiate ones digit (always enabled)
    BCD_Digit ones (
        .clk(clk),
        .reset(reset),
        .en(1'b1),
        .value(q[3:0]),
        .en_out(ones_overflow)
    );
    
    // Instantiate tens digit
    BCD_Digit tens (
        .clk(clk),
        .reset(reset),
        .en(ones_overflow),
        .value(q[7:4]),
        .en_out(tens_overflow)
    );
    
    // Instantiate hundreds digit
    BCD_Digit hundreds (
        .clk(clk),
        .reset(reset),
        .en(ones_overflow & tens_overflow),
        .value(q[11:8]),
        .en_out(hundreds_overflow)
    );
    
    // Instantiate thousands digit
    BCD_Digit thousands (
        .clk(clk),
        .reset(reset),
        .en(ones_overflow & tens_overflow & hundreds_overflow),
        .value(q[15:12]),
        .en_out()  // No higher digit to enable
    );

    // Register enable outputs for better timing
    always @(posedge clk) begin
        if (reset) begin
            ena_reg <= 3'b0;
        end else begin
            ena_reg[0] <= ones_overflow;
            ena_reg[1] <= ones_overflow & tens_overflow;
            ena_reg[2] <= ones_overflow & tens_overflow & hundreds_overflow;
        end
    end

    assign ena = ena_reg;

endmodule