module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out // Declare out as an 8-bit vector
);

    always_comb begin
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
            default: out = 8'b0; // default case to prevent latches
        endcase
    end

endmodule