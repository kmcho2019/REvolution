module TopModule (
    input a,
    input b,
    input sel,
    output reg out
);
    // Alternative implementation using always block
    always @(*) begin
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
        endcase
    end
endmodule