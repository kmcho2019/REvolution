module BCD_Digit_Optimized (
    input clk,
    input reset,
    input en,
    output reg [3:0] value,
    output reg en_out
);

    wire next_en_out = (value == 4'd9) & en;

    always @(posedge clk) begin
        if (reset) begin
            value <= 4'd0;
            en_out <= 1'b0;
        end else begin
            en_out <= next_en_out;
            if (en) begin
                value <= (value == 4'd9) ? 4'd0 : value + 4'd1;
            end
        end
    end

endmodule

module TopModule_Optimized (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg en_ones;
    wire en_tens, en_hundreds;
    
    // Clock gating for ones digit
    always @(posedge clk) begin
        if (reset) begin
            en_ones <= 1'b1;
        end else begin
            en_ones <= 1'b1; // Always enable for counting
        end
    end
    
    // Instantiate ones digit with clock gating
    BCD_Digit_Optimized ones (
        .clk(clk),
        .reset(reset),
        .en(en_ones),
        .value(q[3:0]),
        .en_out(ena[0])
    );
    
    // Instantiate tens digit with registered enable
    BCD_Digit_Optimized tens (
        .clk(clk),
        .reset(reset),
        .en(ena[0]),
        .value(q[7:4]),
        .en_out(en_tens)
    );
    
    // Instantiate hundreds digit with registered enable
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
        .en_out()  // No higher digit to enable
    );
    
    // Register final enable outputs
    always @(posedge clk) begin
        if (reset) begin
            ena[2:1] <= 2'b00;
        end else begin
            ena[1] <= en_tens;
            ena[2] <= en_hundreds;
        end
    end

endmodule