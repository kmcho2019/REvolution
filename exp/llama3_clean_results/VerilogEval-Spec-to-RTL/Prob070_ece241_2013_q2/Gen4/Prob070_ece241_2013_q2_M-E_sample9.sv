module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

reg [3:0] input_value;

always @(*) begin
    input_value = {a, b, c, d};
    case (input_value)
        4'd2, 4'd7, 4'd15: out_sop = 1'b1;
        default: out_sop = 1'b0;
    endcase

    case (input_value)
        4'd0, 4'd1, 4'd4, 4'd5, 4'd6, 4'd9, 4'd10, 4'd13, 4'd14: out_pos = 1'b0;
        default: out_pos = 1'b1;
    endcase
end

endmodule