module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Concatenate inputs into 4-bit vector with a as MSB and d as LSB
    wire [3:0] num = {a, b, c, d};

    // Minimal SOP: out_sop is 1 for num=2,7,15
    // num = 4'b0010 (2), 4'b0111 (7), 4'b1111 (15)
    assign out_sop = (num == 4'd2) | (num == 4'd7) | (num == 4'd15);

    // For out_pos, 0 for num in {0,1,4,5,6,9,10,13,14}, 1 for num in {2,7,15},
    // inputs 3,8,11,12 are don't-cares and thus can be assigned arbitrarily; 
    // we'll treat them as 1 for simplicity.

    reg out_pos_reg;
    always @(*) begin
        case (num)
            4'd0, 4'd1, 4'd4, 4'd5, 4'd6, 4'd9, 4'd10, 4'd13, 4'd14: out_pos_reg = 1'b0;
            4'd2, 4'd7, 4'd15: out_pos_reg = 1'b1;
            // Don't care inputs assigned to 1
            4'd3, 4'd8, 4'd11, 4'd12: out_pos_reg = 1'b1;
            default: out_pos_reg = 1'b0; // safety default
        endcase
    end

    assign out_pos = out_pos_reg;

endmodule