module TopModule (
    input a,
    input b,
    input sel,
    output reg out
);
    // LUT-style implementation using case statement
    always @(*) begin
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
            default: out = 1'bx; // Handle undefined states (good practice)
        endcase
    end
endmodule