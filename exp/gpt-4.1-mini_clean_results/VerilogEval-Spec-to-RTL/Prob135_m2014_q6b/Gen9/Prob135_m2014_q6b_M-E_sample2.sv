module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output reg        Y1
);

    always @(*) begin
        case (y)
            3'b000: Y1 = 0;       // A: next y[1] = 0 (A->B or A->A, y[1] = 0)
            3'b001: Y1 = (w) ? 1 : 0; // B: if w=1 next state D(y=011) y[1]=1 else C(y=010) y[1]=1
            3'b010: Y1 = w ? 1 : 0;   // C: next state D(y=011) y[1]=1 if w=1 else E(y=100) y[1]=0
            3'b011: Y1 = w ? 0 : 1;   // D: next state A(y=000) y[1]=0 if w=1 else F(y=101) y[1]=0
            3'b100: Y1 = 1;            // E: next state E(y=100) or D(y=011), y[1]=1 always
            3'b101: Y1 = w ? 1 : 1;    // F: next state D(y=011) or C(y=010), y[1]=1 always
            default: Y1 = 0;
        endcase
    end

endmodule