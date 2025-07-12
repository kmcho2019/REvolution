module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Using case statement for potential power optimization
    assign out = sel ? a : b;
    /* Alternative case statement version:
    always @(*) begin
        case (sel)
            1'b0: out = b;
            1'b1: out = a;
        endcase
    end
    */

endmodule