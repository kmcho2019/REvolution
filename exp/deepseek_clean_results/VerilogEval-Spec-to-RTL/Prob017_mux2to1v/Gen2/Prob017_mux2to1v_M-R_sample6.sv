module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output reg [99:0] out
);

    always @(*) begin
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
            default: out = a; // Good practice to include default
        endcase
    end

endmodule