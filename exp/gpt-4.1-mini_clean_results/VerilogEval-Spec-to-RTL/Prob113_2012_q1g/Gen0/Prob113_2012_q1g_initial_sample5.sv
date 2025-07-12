module TopModule(
    input  [3:0] x,
    output f
);
    reg f_reg;
    always @(*) begin
        case (x)
            4'd0, 4'd2, 4'd8, 4'd9, 4'd10, 4'd12, 4'd13, 4'd15: f_reg = 1'b1;
            default: f_reg = 1'b0;
        endcase
    end

    assign f = f_reg;
endmodule