module TopModule (
    input x,
    input y,
    output reg z
);

    reg [1:0] state;
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

    always @(*) begin
        case (state)
            S0: z = (x == y);
            S1: z = (x == y);
            S2: z = (x == y);
            S3: z = (x == y);
            default: z = 1'b1;
        endcase
    end

    always @(*) begin
        case (state)
            S0: state = (x & y) ? S1 : S0;
            S1: state = (~x & ~y) ? S2 : S1;
            S2: state = (x & ~y) ? S3 : S2;
            S3: state = (~x & y) ? S0 : S3;
            default: state = S0;
        endcase
    end

    initial begin
        state = S0;
        z = 1'b1;
    end
endmodule