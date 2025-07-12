module TopModule (
    input  [5:0] y,
    input        w,
    output reg   Y1,
    output reg   Y3
);
    always @(*) begin
        // Default next state inputs
        Y1 = 1'b0;
        Y3 = 1'b0;

        case (1'b1) // one-hot encoded current state detection
            y[0]: begin // State A
                // A --1--> B
                if (w) Y1 = 1'b1;
            end
            y[1]: begin // State B
                // B --0--> D
                if (!w) Y3 = 1'b1;
            end
            y[2]: begin // State C
                // C --0--> D
                if (!w) Y3 = 1'b1;
            end
            y[3]: begin // State D
                // D --0--> A (no output to y[1] or y[3])
                // D --1--> F (no output to y[1] or y[3])
            end
            y[4]: begin // State E
                // E --0--> D
                if (!w) Y3 = 1'b1;
            end
            y[5]: begin // State F
                // F --0--> D
                if (!w) Y3 = 1'b1;
            end
            default: begin
                // No state matched, keep outputs 0
                Y1 = 1'b0;
                Y3 = 1'b0;
            end
        endcase
    end

endmodule