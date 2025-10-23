module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);
    // Pack inputs into a 4-bit vector for easy decoding, with a as MSB and d as LSB
    wire [3:0] in_vec = {a,b,c,d};

    always @(*) begin
        case (in_vec)
            4'd2, 4'd7, 4'd15: out_sop = 1'b1;   // output 1 for these decimal values
            4'd0, 4'd1, 4'd4, 4'd5, 4'd6,
            4'd9, 4'd10, 4'd13, 4'd14: out_sop = 1'b0; // output 0 for these decimal values
            default: out_sop = 1'b0; // for "never occur" inputs and others, output 0
        endcase
    end

    // out_pos is 1 when output should be zero (i.e., complement of out_sop)
    always @(*) begin
        out_pos = ~out_sop;
    end

endmodule