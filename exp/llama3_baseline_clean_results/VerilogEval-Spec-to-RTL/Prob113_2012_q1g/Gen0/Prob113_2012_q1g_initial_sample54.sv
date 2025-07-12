module TopModule(
    input [3:0] x,
    output f
);

always @(x) begin
    case ({x[2], x[3]})
        2'b00: begin
            case ({x[0], x[1]})
                2'b00, 2'b10: f = 1'b1;
                default: f = 1'b0;
            endcase
        end
        2'b01: f = 1'b0;
        2'b11: begin
            case ({x[0], x[1]})
                2'b00, 2'b01, 2'b11: f = 1'b1;
                default: f = 1'b0;
            endcase
        end
        2'b10: begin
            case ({x[0], x[1]})
                2'b00, 2'b01, 2'b10: f = 1'b1;
                default: f = 1'b0;
            endcase
        end
    endcase
end

endmodule