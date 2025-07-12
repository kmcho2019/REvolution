module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] lfsr;

always @(posedge clk) begin
    if (reset) begin
        lfsr <= 4'd0;
    end else begin
        // X^4 + X + 1 is a primitive polynomial for a 4-bit LFSR
        // with a period of 15. To get a period of 16, we use the
        // polynomial X^4 + X^3 + X^2 + X + 1, but this would not
        // generate all possible 4-bit values. Instead, we use the
        // given polynomial and adjust the LFSR to produce the desired
        // counting sequence.
        lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[0]};
    end
end

// To get the desired counting sequence, we use a simple encoding.
assign q = (lfsr == 4'd0)? 4'd0 :
           (lfsr == 4'd1)? 4'd1 :
           (lfsr == 4'd2)? 4'd2 :
           (lfsr == 4'd3)? 4'd3 :
           (lfsr == 4'd4)? 4'd4 :
           (lfsr == 4'd5)? 4'd5 :
           (lfsr == 4'd6)? 4'd6 :
           (lfsr == 4'd7)? 4'd7 :
           (lfsr == 4'd8)? 4'd8 :
           (lfsr == 4'd9)? 4'd9 :
           (lfsr == 4'd10)? 4'd10 :
           (lfsr == 4'd11)? 4'd11 :
           (lfsr == 4'd12)? 4'd12 :
           (lfsr == 4'd13)? 4'd13 :
           (lfsr == 4'd14)? 4'd14 :
           (lfsr == 4'd15)? 4'd15 :
           4'd0;

endmodule