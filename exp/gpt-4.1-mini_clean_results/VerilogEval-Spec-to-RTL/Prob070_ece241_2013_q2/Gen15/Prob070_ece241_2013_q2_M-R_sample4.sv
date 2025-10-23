module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

    wire [3:0] in_vec = {a,b,c,d};

    always @(*) begin
        case(in_vec)
            4'd2, 4'd7, 4'd15: out_sop = 1'b1;
            4'd0,4'd1,4'd4,4'd5,4'd6,4'd9,4'd10,4'd13,4'd14: out_sop = 1'b0;
            default: out_sop = 1'b0; // For never occurring inputs or default
        endcase
    end

    always @(*) begin
        case(in_vec)
            // For out_pos = 1 only when input is 2,7,15 (same as out_sop)
            4'd2, 4'd7, 4'd15: out_pos = 1'b1;
            4'd0,4'd1,4'd4,4'd5,4'd6,4'd9,4'd10,4'd13,4'd14: out_pos = 1'b0;
            default: out_pos = 1'b0;
        endcase
    end

endmodule