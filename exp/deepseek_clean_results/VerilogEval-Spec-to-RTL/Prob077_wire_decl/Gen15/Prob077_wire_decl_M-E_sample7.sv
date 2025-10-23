module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg out,
    output reg out_n
);
    always @(*) begin
        case ({a, b, c, d})
            4'b0000: begin out = 1'b0; out_n = 1'b1; end
            4'b0001: begin out = 1'b0; out_n = 1'b1; end
            4'b0010: begin out = 1'b0; out_n = 1'b1; end
            4'b0011: begin out = 1'b1; out_n = 1'b0; end
            4'b0100: begin out = 1'b0; out_n = 1'b1; end
            4'b0101: begin out = 1'b0; out_n = 1'b1; end
            4'b0110: begin out = 1'b0; out_n = 1'b1; end
            4'b0111: begin out = 1'b1; out_n = 1'b0; end
            4'b1000: begin out = 1'b0; out_n = 1'b1; end
            4'b1001: begin out = 1'b0; out_n = 1'b1; end
            4'b1010: begin out = 1'b0; out_n = 1'b1; end
            4'b1011: begin out = 1'b1; out_n = 1'b0; end
            4'b1100: begin out = 1'b1; out_n = 1'b0; end
            4'b1101: begin out = 1'b1; out_n = 1'b0; end
            4'b1110: begin out = 1'b1; out_n = 1'b0; end
            4'b1111: begin out = 1'b1; out_n = 1'b0; end
        endcase
    end
endmodule