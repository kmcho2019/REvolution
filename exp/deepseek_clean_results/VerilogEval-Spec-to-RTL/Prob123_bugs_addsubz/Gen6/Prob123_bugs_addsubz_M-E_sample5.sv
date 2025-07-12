module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] b_adj = do_sub ? ~b : b;
    wire [7:0] sum, carry;
    wire early_zero_pred;

    // Carry-save addition stage
    assign sum = a ^ b_adj;
    assign carry = (a & b_adj) << 1;

    // Early zero prediction (a == b for add, a == -b for sub)
    assign early_zero_pred = (a == (do_sub ? ~b : b));

    // Final addition and zero detection
    always @(*) begin
        out = sum + carry + (do_sub ? 8'd1 : 8'd0);
        
        // Combined zero detection (early prediction OR actual zero)
        result_is_zero = early_zero_pred | ~(|out);
    end

endmodule