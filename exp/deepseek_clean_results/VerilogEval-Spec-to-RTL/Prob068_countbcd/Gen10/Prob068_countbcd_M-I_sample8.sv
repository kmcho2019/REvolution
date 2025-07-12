module BCD_Digit_Optimized (
    input clk,
    input reset,
    input en,
    output reg [3:0] value,
    output reg en_out
);

    wire rollover = (value == 4'd9) & en;

    always @(posedge clk) begin
        if (reset) begin
            value <= 4'd0;
            en_out <= 1'b0;
        end else begin
            if (en) begin
                if (value == 4'd9) begin
                    value <= 4'd0;
                end else begin
                    value <= value + 4'd1;
                end
            end
            en_out <= rollover;
        end
    end

endmodule

module TopModule_Optimized (
    input clk,
    input reset,
    output reg [2:0] ena,
    output [15:0] q
);

    reg en_tens, en_hundreds;
    wire ones_clock;
    
    // Clock gating for ones digit
    assign ones_clock = clk & (ena[0] | reset);
    
    // Instantiate ones digit with clock gating
    BCD_Digit_Optimized ones (
        .clk(ones_clock),
        .reset(reset),
        .en(1'b1),
        .value(q[3:0]),
        .en_out(ena[0])
    );
    
    // Instantiate tens digit
    BCD_Digit_Optimized tens (
        .clk(clk),
        .reset(reset),
        .en(ena[0]),
        .value(q[7:4]),
        .en_out(en_tens)
    );
    
    // Instantiate hundreds digit
    BCD_Digit_Optimized hundreds (
        .clk(clk),
        .reset(reset),
        .en(en_tens),
        .value(q[11:8]),
        .en_out(en_hundreds)
    );
    
    // Instantiate thousands digit
    BCD_Digit_Optimized thousands (
        .clk(clk),
        .reset(reset),
        .en(en_hundreds),
        .value(q[15:12]),
        .en_out()
    );
    
    // Register all enable outputs
    always @(posedge clk) begin
        if (reset) begin
            ena[2:1] <= 2'b00;
        end else begin
            ena[1] <= en_tens;
            ena[2] <= en_hundreds;
        end
    end

endmodule