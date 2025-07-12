module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

    // Combine inputs into a 4-bit vector for easy case analysis
    wire [3:0] in = {a, b, c, d};

    // Combinational logic for out_sop: logic-1 for inputs 2,7,15; else 0
    always @(*) begin
        case (in)
            4'd2,  // 0010
            4'd7,  // 0111
            4'd15: // 1111
                out_sop = 1'b1;
            default:
                out_sop = 1'b0;
        endcase
    end

    // Combinational logic for out_pos: logic-0 for 0,1,4,5,6,9,10,13,14; else 1
    always @(*) begin
        case (in)
            4'd0,  // 0000
            4'd1,  // 0001
            4'd4,  // 0100
            4'd5,  // 0101
            4'd6,  // 0110
            4'd9,  // 1001
            4'd10, // 1010
            4'd13, // 1101
            4'd14: // 1110
                out_pos = 1'b0;
            default:
                out_pos = 1'b1;
        endcase
    end

endmodule