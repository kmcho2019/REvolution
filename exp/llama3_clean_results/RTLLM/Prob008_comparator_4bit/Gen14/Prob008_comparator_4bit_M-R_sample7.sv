module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output reg        A_greater,
    output reg        A_equal,
    output reg        A_less
);

    always @(*) begin
        case ({A, B})
            {4'd0, 4'd0}, {4'd1, 4'd1}, {4'd2, 4'd2}, {4'd3, 4'd3}, 
            {4'd4, 4'd4}, {4'd5, 4'd5}, {4'd6, 4'd6}, {4'd7, 4'd7}, 
            {4'd8, 4'd8}, {4'd9, 4'd9}, {4'd10, 4'd10}, {4'd11, 4'd11}, 
            {4'd12, 4'd12}, {4'd13, 4'd13}, {4'd14, 4'd14}, {4'd15, 4'd15}: 
                begin A_greater = 0; A_equal = 1; A_less = 0; end
            default: 
                if (A > B) begin A_greater = 1; A_equal = 0; A_less = 0; end
                else if (A < B) begin A_greater = 0; A_equal = 0; A_less = 1; end
                else begin A_greater = 0; A_equal = 1; A_less = 0; end
        endcase
    end

endmodule