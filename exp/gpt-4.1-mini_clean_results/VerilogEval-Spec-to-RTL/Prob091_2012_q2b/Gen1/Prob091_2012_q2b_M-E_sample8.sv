module TopModule(
    input  [5:0] y,
    input        w,
    output reg   Y1,
    output reg   Y3
);

always @(*) begin
    // Default outputs
    Y1 = 1'b0;
    Y3 = 1'b0;

    case ({y, w})
        // Format: {y[5], y[4], y[3], y[2], y[1], y[0], w}

        // State A (000001): transitions depend on w
        7'b0000010: begin // y=A, w=0
            // A(0) --0--> A, no transition to B or D
            Y1 = 1'b0;
            Y3 = 1'b0;
        end
        7'b0000011: begin // y=A, w=1
            // A(0) --1--> B
            Y1 = 1'b1; // input to y[1]
            Y3 = 1'b0;
        end

        // State B (000010): transitions depend on w
        7'b0000100: begin // y=B, w=0
            // B(0) --0--> D
            Y1 = 1'b0;
            Y3 = 1'b1; // input to y[3]
        end
        7'b0000101: begin // y=B, w=1
            // B(0) --1--> C (no input to y[1] or y[3])
            Y1 = 1'b0;
            Y3 = 1'b0;
        end

        // State C (000100): transitions depend on w
        7'b0001000: begin // y=C, w=0
            // C(0) --0--> D
            Y1 = 1'b0;
            Y3 = 1'b1;
        end
        7'b0001001: begin // y=C, w=1
            // C(0) --1--> E (no input to y[1] or y[3])
            Y1 = 1'b0;
            Y3 = 1'b0;
        end

        // State D (001000): transitions depend on w
        7'b0010000: begin // y=D, w=0
            // D(0) --0--> A (no input to y[1] or y[3])
            Y1 = 1'b0;
            Y3 = 1'b0;
        end
        7'b0010001: begin // y=D, w=1
            // D(0) --1--> F (no input to y[1] or y[3])
            Y1 = 1'b0;
            Y3 = 1'b0;
        end

        // State E (010000): transitions depend on w
        7'b0100000: begin // y=E, w=0
            // E(1) --0--> D
            Y1 = 1'b0;
            Y3 = 1'b1;
        end
        7'b0100001: begin // y=E, w=1
            // E(1) --1--> E (no input to y[1] or y[3])
            Y1 = 1'b0;
            Y3 = 1'b0;
        end

        // State F (100000): transitions depend on w
        7'b1000000: begin // y=F, w=0
            // F(1) --0--> D
            Y1 = 1'b0;
            Y3 = 1'b1;
        end
        7'b1000001: begin // y=F, w=1
            // F(1) --1--> C (no input to y[1] or y[3])
            Y1 = 1'b0;
            Y3 = 1'b0;
        end

        default: begin
            Y1 = 1'b0;
            Y3 = 1'b0;
        end
    endcase
end

endmodule