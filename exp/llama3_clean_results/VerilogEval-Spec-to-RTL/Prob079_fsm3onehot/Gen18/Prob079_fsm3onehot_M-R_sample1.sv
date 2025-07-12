module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    always_comb begin
        case (state)
            A: next_state = (in)? B : A;
            B: next_state = (in)? B : C;
            C: next_state = (in)? D : A;
            D: next_state = (in)? B : C;
            default: next_state = A;
        endcase

        case (state)
            A, B, C: out = 1'b0;
            D: out = 1'b1;
            default: out = 1'b0;
        endcase
    end
endmodule