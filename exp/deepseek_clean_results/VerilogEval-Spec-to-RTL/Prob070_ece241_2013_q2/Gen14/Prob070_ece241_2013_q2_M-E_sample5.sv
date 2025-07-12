module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    wire [3:0] input_vec = {a, b, c, d};
    reg sop_result;
    reg pos_intermediate;

    // SOP implementation
    always @(*) begin
        case (input_vec)
            4'b0010: sop_result = 1'b1;  // 2
            4'b0111: sop_result = 1'b1;  // 7
            4'b1111: sop_result = 1'b1;  // 15
            default: sop_result = 1'b0;  // All other cases including don't-cares
        endcase
    end

    // POS implementation (complement of cases where output is 0)
    always @(*) begin
        case (input_vec)
            4'b0000,  // 0
            4'b0001,  // 1
            4'b0100,  // 4
            4'b0101,  // 5
            4'b0110,  // 6
            4'b1001,  // 9
            4'b1010,  // 10
            4'b1101,  // 13
            4'b1110:  // 14
                pos_intermediate = 1'b0;
            default: pos_intermediate = 1'b1;  // All other cases
        endcase
    end

    assign out_sop = sop_result;
    assign out_pos = pos_intermediate;

endmodule