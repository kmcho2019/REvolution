module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    always @(*)
    begin
        case (1'b1)
            y[0] & w: Y1 = 1'b1; // State A to B
            default: Y1 = 1'b0;
        endcase

        case (1'b1)
            ~w & (y[1] | y[2] | y[4] | y[5]): Y3 = 1'b1; // Transition to state D
            default: Y3 = 1'b0;
        endcase
    end

endmodule