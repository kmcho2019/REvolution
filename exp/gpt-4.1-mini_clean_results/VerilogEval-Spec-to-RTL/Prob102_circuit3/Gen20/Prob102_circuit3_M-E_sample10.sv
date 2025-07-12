module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

    always @(*) begin
        case ({a,b,c,d})
            4'b0111,
            4'b0110,
            4'b0101,
            4'b0100,
            4'b1011,
            4'b1010,
            4'b1001,
            4'b1101,
            4'b1100,
            4'b1111,
            4'b1110,
            4'b1101: q = 1'b1;  // all cases with q=1 from waveforms
            default:    q = 1'b0;
        endcase
    end

endmodule