module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    always @(*) begin
        case(in)
            4'b0000: begin
                out_and = 0;
                out_or = 0;
                out_xor = 0;
            end
            4'b0001: begin
                out_and = 0;
                out_or = 1;
                out_xor = 1;
            end
            4'b0010: begin
                out_and = 0;
                out_or = 1;
                out_xor = 1;
            end
            4'b0011: begin
                out_and = 0;
                out_or = 1;
                out_xor = 0;
            end
            4'b0100: begin
                out_and = 0;
                out_or = 1;
                out_xor = 1;
            end
            4'b0101: begin
                out_and = 0;
                out_or = 1;
                out_xor = 0;
            end
            4'b0110: begin
                out_and = 0;
                out_or = 1;
                out_xor = 0;
            end
            4'b0111: begin
                out_and = 0;
                out_or = 1;
                out_xor = 1;
            end
            4'b1000: begin
                out_and = 0;
                out_or = 1;
                out_xor = 1;
            end
            4'b1001: begin
                out_and = 0;
                out_or = 1;
                out_xor = 0;
            end
            4'b1010: begin
                out_and = 0;
                out_or = 1;
                out_xor = 0;
            end
            4'b1011: begin
                out_and = 0;
                out_or = 1;
                out_xor = 1;
            end
            4'b1100: begin
                out_and = 0;
                out_or = 1;
                out_xor = 0;
            end
            4'b1101: begin
                out_and = 0;
                out_or = 1;
                out_xor = 1;
            end
            4'b1110: begin
                out_and = 0;
                out_or = 1;
                out_xor = 1;
            end
            4'b1111: begin
                out_and = 1;
                out_or = 1;
                out_xor = 0;
            end
            default: begin
                out_and = 0;
                out_or = 0;
                out_xor = 0;
            end
        endcase
    end
endmodule