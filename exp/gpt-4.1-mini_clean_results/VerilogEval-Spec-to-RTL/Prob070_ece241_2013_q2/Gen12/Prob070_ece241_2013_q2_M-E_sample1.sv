module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Combine inputs into a 4-bit vector, MSB=a, LSB=d
    wire [3:0] in_vec = {a,b,c,d};

    reg sop_val;

    always @(*) begin
        case(in_vec)
            4'd2, 4'd7, 4'd15: sop_val = 1'b1; // specified ones
            4'd0, 4'd1, 4'd4, 4'd5, 4'd6,
            4'd9, 4'd10, 4'd13, 4'd14: sop_val = 1'b0; // specified zeros
            // For undefined inputs (3,8,11,12), assign 0 by default
            default: sop_val = 1'b0;
        endcase
    end

    assign out_sop = sop_val;

    // out_pos is logical complement of out_sop
    assign out_pos = ~out_sop;

endmodule