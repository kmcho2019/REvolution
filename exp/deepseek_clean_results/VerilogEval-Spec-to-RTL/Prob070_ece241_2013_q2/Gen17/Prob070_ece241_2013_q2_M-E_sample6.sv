module TopModule (
    input  a, b, c, d,
    output reg out_sop,
    output reg out_pos
);

    // Combine inputs for case statement
    wire [3:0] inputs = {a, b, c, d};

    // SOP implementation (sum of products)
    always @(*) begin
        case (inputs)
            4'b0010: out_sop = 1'b1;  // 2
            4'b0111: out_sop = 1'b1;  // 7
            4'b1111: out_sop = 1'b1;  // 15
            // Explicit 0-output cases
            4'b0000: out_sop = 1'b0;  // 0
            4'b0001: out_sop = 1'b0;  // 1
            4'b0100: out_sop = 1'b0;  // 4
            4'b0101: out_sop = 1'b0;  // 5
            4'b0110: out_sop = 1'b0;  // 6
            4'b1001: out_sop = 1'b0;  // 9
            4'b1010: out_sop = 1'b0;  // 10
            4'b1101: out_sop = 1'b0;  // 13
            4'b1110: out_sop = 1'b0;  // 14
            // Don't-care cases default to 0
            default: out_sop = 1'b0;   // 3,8,11,12
        endcase
    end

    // POS implementation (product of sums)
    always @(*) begin
        case (inputs)
            // Maxterms (output 0 cases)
            4'b0000: out_pos = 1'b0;  // 0
            4'b0001: out_pos = 1'b0;  // 1
            4'b0100: out_pos = 1'b0;  // 4
            4'b0101: out_pos = 1'b0;  // 5
            4'b0110: out_pos = 1'b0;  // 6
            4'b1001: out_pos = 1'b0;  // 9
            4'b1010: out_pos = 1'b0;  // 10
            4'b1101: out_pos = 1'b0;  // 13
            4'b1110: out_pos = 1'b0;  // 14
            // Output 1 cases
            4'b0010: out_pos = 1'b1;  // 2
            4'b0111: out_pos = 1'b1;  // 7
            4'b1111: out_pos = 1'b1;  // 15
            // Don't-care cases default to 1 (for POS)
            default: out_pos = 1'b1;   // 3,8,11,12
        endcase
    end

endmodule