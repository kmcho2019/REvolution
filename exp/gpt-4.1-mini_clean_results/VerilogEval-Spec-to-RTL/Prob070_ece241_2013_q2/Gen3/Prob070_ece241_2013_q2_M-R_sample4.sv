module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

    // Combine inputs into a 4-bit vector with a as MSB and d as LSB
    wire [3:0] num = {a, b, c, d};

    always @(*) begin
        // Default outputs
        out_sop = 0;
        out_pos = 1;

        case (num)
            // Outputs '1' for decimal 2,7,15 (for out_sop)
            4'd2, 4'd7, 4'd15: begin
                out_sop = 1;
                out_pos = 1; // Since out_pos is POS of zeros, should be 1 here
            end
            // Outputs '0' for decimal 0,1,4,5,6,9,10,13,14 (for out_pos)
            4'd0, 4'd1, 4'd4, 4'd5, 4'd6, 4'd9, 4'd10, 4'd13, 4'd14: begin
                out_sop = 0;
                out_pos = 0;
            end
            // Invalid inputs 3,8,11,12 (don't care) - outputs default (0 for out_sop, 1 for out_pos)
            default: begin
                out_sop = 0;
                out_pos = 1;
            end
        endcase
    end

endmodule