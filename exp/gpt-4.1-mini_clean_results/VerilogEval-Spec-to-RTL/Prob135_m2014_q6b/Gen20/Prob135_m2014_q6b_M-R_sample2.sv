module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output reg        Y1
);

    always @(*) begin
        case (y)
            3'b000: Y1 = 1'b0; // A: y=000, y[1]=0
            3'b001: Y1 = w ? 1'b1 : 1'b0; // B: y=001; next y[1] depends on w (to D=011 or C=010)
            3'b010: Y1 = w ? 1'b1 : 1'b0; // C: y=010; next y[1] depends on w (D=011 or E=100)
            3'b011: Y1 = w ? 1'b0 : 1'b1; // D: y=011; next y[1] depends on w (A=000 or F=101)
            3'b100: Y1 = 1'b1;             // E: y=100; y[1] = 1
            3'b101: Y1 = 1'b1;             // F: y=101; y[1] = 1
            default: Y1 = 1'b0;
        endcase
    end

endmodule