module TopModule (
    input a,
    input b,
    input sel,
    output reg out
);
    // 2-to-1 mux implemented as a lookup table
    always @(*) begin
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
            default: out = 1'bx; // handle undefined states (good practice)
        endcase
    end
endmodule