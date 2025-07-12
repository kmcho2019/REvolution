module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg q
);

    always @(*) begin
        case ({a,b,c,d})
            4'b0101, 4'b0110, 4'b0111, // b=1 and (c or d)
            4'b1001, 4'b1010, 4'b1011, // a=1 and (c or d)
            4'b1101, 4'b1110, 4'b1111: // a=1 and b=1 and (c or d)
                q = 1'b1;
            default:
                q = 1'b0;
        endcase
    end

endmodule