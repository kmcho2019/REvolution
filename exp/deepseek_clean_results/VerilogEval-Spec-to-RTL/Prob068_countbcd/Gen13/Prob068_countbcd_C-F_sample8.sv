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

    // Digit instances
    BCD_Digit ones (
        .clk(clk),
        .reset(reset),
        .en(1'b1),
        .value(q[3:0]),
        .en_out(ena[0])
    );
    
    BCD_Digit tens (
        .clk(clk),
        .reset(reset),
        .en(ena[0]),
        .value(q[7:4]),
        .en_out(ena[1])
    );
    
    BCD_Digit hundreds (
        .clk(clk),
        .reset(reset),
        .en(ena[1]),
        .value(q[11:8]),
        .en_out(ena[2])
    );
    
    BCD_Digit thousands (
        .clk(clk),
        .reset(reset),
        .en(ena[2]),
        .value(q[15:12]),
        .en_out()  // No higher digit to enable
    );

endmodule