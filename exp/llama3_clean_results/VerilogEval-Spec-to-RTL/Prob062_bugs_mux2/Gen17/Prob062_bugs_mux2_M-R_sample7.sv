module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    wire [7:0] out;
    
    always @(*)
    begin
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
            default: out = 8'b0; // handle unknown or X value of sel
        endcase
    end

endmodule