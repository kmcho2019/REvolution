module TopModule(
    input  [5:0] y,   // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y2,  // next state bit corresponding to B (y[1])
    output       Y4   // next state bit corresponding to D (y[3])
);

    reg next_B, next_D;

    always @(*) begin
        // Default outputs
        next_B = 1'b0;
        next_D = 1'b0;

        case (1'b1)  // one-hot encoded current state: exactly one bit is 1
            y[0]: begin // state A
                // A --0--> B
                if (w == 1'b0) next_B = 1'b1;
                // A --1--> A (no effect on B or D outputs)
            end
            y[1]: begin // state B
                // B --1--> D
                if (w == 1'b1) next_D = 1'b1;
                // B --0--> C (not relevant to B or D outputs)
            end
            y[2]: begin // state C
                // C --1--> D
                if (w == 1'b1) next_D = 1'b1;
                // C --0--> E (no effect on B or D)
            end
            y[3]: begin // state D
                // D --1--> A (no)
                // D --0--> F (no B or D)
            end
            y[4]: begin // state E
                // E --1--> D
                if (w == 1'b1) next_D = 1'b1;
                // E --0--> E (no B or D)
            end
            y[5]: begin // state F
                // F --1--> D
                if (w == 1'b1) next_D = 1'b1;
                // F --0--> C (no B or D)
            end
            default: begin
                // In case none matched, keep outputs zero
                next_B = 1'b0;
                next_D = 1'b0;
            end
        endcase
    end

    assign Y2 = next_B;
    assign Y4 = next_D;

endmodule