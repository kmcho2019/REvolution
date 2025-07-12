module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // Define the lookup table based on the state machine's transitions
    // For each state, specify the next state of Y1 and Y3 based on w
    // Since we're using one-hot encoding, we only need to consider the cases where y[i] = 1
    always @(*) begin
        case (1'b1)
            y[0]: // State A
                if (w) begin
                    Y1 = 1'b1; // Transition to B
                    Y3 = 1'b0;
                end else begin
                    Y1 = 1'b0; // Stay in A
                    Y3 = 1'b0;
                end
            y[1]: // State B
                if (w) begin
                    Y1 = 1'b0; // Transition to C
                    Y3 = 1'b0;
                end else begin
                    Y1 = 1'b0; // Transition to D
                    Y3 = 1'b1;
                end
            y[2]: // State C
                if (w) begin
                    Y1 = 1'b0; // Transition to E
                    Y3 = 1'b0;
                end else begin
                    Y1 = 1'b0; // Transition to D
                    Y3 = 1'b1;
                end
            y[3]: // State D
                if (w) begin
                    Y1 = 1'b0; // Transition to F
                    Y3 = 1'b0;
                end else begin
                    Y1 = 1'b0; // Transition to A
                    Y3 = 1'b0;
                end
            y[4]: // State E
                if (w) begin
                    Y1 = 1'b0; // Stay in E
                    Y3 = 1'b0;
                end else begin
                    Y1 = 1'b0; // Transition to D
                    Y3 = 1'b1;
                end
            y[5]: // State F
                if (w) begin
                    Y1 = 1'b0; // Transition to C
                    Y3 = 1'b0;
                end else begin
                    Y1 = 1'b0; // Transition to D
                    Y3 = 1'b1;
                end
            default:
                Y1 = 1'b0;
                Y3 = 1'b0;
        endcase
    end

endmodule