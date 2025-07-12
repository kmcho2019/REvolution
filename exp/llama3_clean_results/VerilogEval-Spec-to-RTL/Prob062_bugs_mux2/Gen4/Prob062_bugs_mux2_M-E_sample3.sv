module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    always @(sel, a, b) begin
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
            default: out = 8'b0; // Optional: default value when sel is not 0 or 1
        endcase
    end

endmodule