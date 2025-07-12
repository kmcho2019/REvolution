module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

wire [1:0] ab = {a,b};
wire [1:0] cd = {c,d};

reg out_reg;

always @(*) begin
    case(cd)
        2'b00: begin
            case(ab)
                2'b00: out_reg = 1'b1;
                2'b01: out_reg = 1'b1;
                2'b11: out_reg = 1'b0;
                2'b10: out_reg = 1'b1;
                default: out_reg = 1'b0;
            endcase
        end
        2'b01: begin
            case(ab)
                2'b00: out_reg = 1'b1;
                2'b01: out_reg = 1'b0;
                2'b11: out_reg = 1'b0;
                2'b10: out_reg = 1'b1;
                default: out_reg = 1'b0;
            endcase
        end
        2'b11: begin
            case(ab)
                2'b00: out_reg = 1'b0;
                2'b01: out_reg = 1'b1;
                2'b11: out_reg = 1'b1;
                2'b10: out_reg = 1'b1;
                default: out_reg = 1'b0;
            endcase
        end
        2'b10: begin
            case(ab)
                2'b00: out_reg = 1'b1;
                2'b01: out_reg = 1'b1;
                2'b11: out_reg = 1'b0;
                2'b10: out_reg = 1'b0;
                default: out_reg = 1'b0;
            endcase
        end
        default: out_reg = 1'b0;
    endcase
end

assign out = out_reg;

endmodule