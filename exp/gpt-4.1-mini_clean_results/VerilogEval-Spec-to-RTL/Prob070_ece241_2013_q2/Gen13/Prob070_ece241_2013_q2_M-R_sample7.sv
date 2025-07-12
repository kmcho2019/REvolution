module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

    // Combine inputs into a 4-bit vector (a as MSB)
    wire [3:0] in_val = {a, b, c, d};

    always @(*) begin
        case (in_val)
            4'd2,   // 0010
            4'd7,   // 0111
            4'd15:  // 1111
                begin
                    out_sop = 1'b1;
                    out_pos = 1'b1;
                end
            4'd0,   // 0000
            4'd1,   // 0001
            4'd4,   // 0100
            4'd5,   // 0101
            4'd6,   // 0110
            4'd9,   // 1001
            4'd10,  // 1010
            4'd13,  // 1101
            4'd14:  // 1110
                begin
                    out_sop = 1'b0;
                    out_pos = 1'b0;
                end
            // Don't-care inputs: 3,8,11,12 - assign outputs to 0 safely
            4'd3,   // 0011
            4'd8,   // 1000
            4'd11,  // 1011
            4'd12:  // 1100
                begin
                    out_sop = 1'b0;
                    out_pos = 1'b0;
                end
            default:
                begin
                    // For any other unexpected inputs, assign 0
                    out_sop = 1'b0;
                    out_pos = 1'b0;
                end
        endcase
    end

endmodule