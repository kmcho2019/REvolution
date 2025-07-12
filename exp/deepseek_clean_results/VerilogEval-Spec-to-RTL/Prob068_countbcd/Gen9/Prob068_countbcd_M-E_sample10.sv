module BCD_Digit (
    input clk,
    input reset,
    input en,
    output reg [3:0] value,
    output en_out
);

    always @(posedge clk) begin
        if (reset) begin
            value <= 4'd0;
        end else if (en) begin
            if (value == 4'd9) begin
                value <= 4'd0;
            end else begin
                value <= value + 4'd1;
            end
        end
    end

    assign en_out = (value == 4'd9) & en;

endmodule

module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    wire en_tens, en_hundreds, en_thousands;
    
    // Instantiate ones digit (always enabled)
    BCD_Digit ones (
        .clk(clk),
        .reset(reset),
        .en(1'b1),
        .value(q[3:0]),
        .en_out(ena[0])
    );
    
    // Instantiate tens digit
    BCD_Digit tens (
        .clk(clk),
        .reset(reset),
        .en(ena[0]),
        .value(q[7:4]),
        .en_out(en_tens)
    );
    assign ena[1] = en_tens;
    
    // Instantiate hundreds digit
    BCD_Digit hundreds (
        .clk(clk),
        .reset(reset),
        .en(en_tens),
        .value(q[11:8]),
        .en_out(en_hundreds)
    );
    assign ena[2] = en_hundreds;
    
    // Instantiate thousands digit
    BCD_Digit thousands (
        .clk(clk),
        .reset(reset),
        .en(en_hundreds),
        .value(q[15:12]),
        .en_out()  // No higher digit to enable
    );

endmodule