module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    always @(a, b, sel) begin
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
            default: out = 8'b0; // Handle undefined select signal
        endcase
    end

endmodule