module TopModule(
    input  [3:0] x,
    output       f
);

    reg f_reg;
    always @(*) begin
        case ({x[2], x[3]})
            2'b00: begin
                case ({x[0], x[1]})
                    2'b00, 2'b10: f_reg = 1'b1;
                    default: f_reg = 1'b0;
                endcase
            end
            2'b01: begin
                f_reg = 1'b0;
            end
            2'b11: begin
                case ({x[0], x[1]})
                    2'b00, 2'b01, 2'b11: f_reg = 1'b1;
                    default: f_reg = 1'b0;
                endcase
            end
            2'b10: begin
                case ({x[0], x[1]})
                    2'b00, 2'b01, 2'b10: f_reg = 1'b1;
                    default: f_reg = 1'b0;
                endcase
            end
        endcase
    end

    assign f = f_reg;

endmodule