module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Next state computation for Y1 (next y[1]) and Y3 (next y[3])
    always @(*) begin
        case (1'b1)
            y[0]: begin // State A
                Y1 = w;       // Next y[1] is 1 if w=1 (transition to B)
                Y3 = 1'b0;   // Next y[3] is always 0 from A
            end
            y[1]: begin // State B
                Y1 = 1'b0;    // Next y[1] is always 0 (leaving B)
                Y3 = ~w;      // Next y[3] is 1 if w=0 (transition to D)
            end
            y[2]: begin // State C
                Y1 = 1'b0;    // Next y[1] is always 0
                Y3 = ~w;      // Next y[3] is 1 if w=0 (transition to D)
            end
            y[3]: begin // State D
                Y1 = 1'b0;    // Next y[1] is always 0
                Y3 = ~w;       // Next y[3] is 1 if w=0 (transition to A)
            end
            y[4]: begin // State E
                Y1 = 1'b0;    // Next y[1] is always 0
                Y3 = ~w;      // Next y[3] is 1 if w=0 (transition to D)
            end
            y[5]: begin // State F
                Y1 = 1'b0;    // Next y[1] is always 0
                Y3 = ~w;      // Next y[3] is 1 if w=0 (transition to D)
            end
            default: begin
                Y1 = 1'b0;
                Y3 = 1'b0;
            end
        endcase
    end

endmodule