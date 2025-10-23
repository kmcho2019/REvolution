module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    always @(*) begin
        case (y)
            6'b000001: begin // State A
                if (~w) Y1 = 1'b1; // Transition to state B
                else Y1 = 1'b0;
                Y3 = 1'b0;
            end
            6'b000010: begin // State B
                if (~w) Y1 = 1'b0; // Transition to state C
                else Y1 = 1'b0;
                Y3 = 1'b0;
            end
            6'b000100: begin // State C
                if (~w) Y1 = 1'b0; // Transition to state E
                else Y1 = 1'b0;
                Y3 = 1'b0;
            end
            6'b001000: begin // State D
                if (~w) Y1 = 1'b0; // Transition to state F
                else Y1 = 1'b1; // Transition to state A
                if (w) Y3 = 1'b0; // Transition to state A
                else Y3 = 1'b0;
            end
            6'b010000: begin // State E
                if (~w) Y1 = 1'b0; // Remain in state E
                else Y1 = 1'b0;
                if (w) Y3 = 1'b0; // Transition to state D
                else Y3 = 1'b0;
            end
            6'b100000: begin // State F
                if (~w) Y1 = 1'b0; // Transition to state C
                else Y1 = 1'b0;
                if (~w) Y3 = 1'b0; // Transition to state C
                else Y3 = 1'b1; // Transition to state D
            end
            default: begin
                Y1 = 1'b0;
                Y3 = 1'b0;
            end
        endcase
    end

endmodule