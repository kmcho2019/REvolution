module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output reg [99:0] out
);

    always_comb begin
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
            default: out = a; // Default case for robustness
        endcase
    end

endmodule