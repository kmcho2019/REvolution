module TopModule (
    input  [3:0] in,      // 4-bit input
    output reg   out_and,  // AND reduction output
    output reg   out_or,   // OR reduction output
    output reg   out_xor   // XOR reduction output
);

    always @* begin
        case (in)
            4'b0000: begin
                out_and = 1'b0;
                out_or  = 1'b0;
                out_xor = 1'b0;
            end
            default: begin
                out_and = &in;
                out_or  = |in;
                out_xor = ^in;
            end
        endcase
    end
endmodule