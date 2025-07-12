module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Next state bits (only Y1 and Y3 needed as outputs)
    wire next_Y1, next_Y3;

    // State transition logic using casez for one-hot encoding
    always @(*) begin
        casez (y)
            6'b000001: begin // State A
                next_Y1 = w;
                next_Y3 = 1'b0;
            end
            6'b000010: begin // State B
                next_Y1 = 1'b0;
                next_Y3 = ~w;
            end
            6'b000100: begin // State C
                next_Y1 = 1'b0;
                next_Y3 = ~w;
            end
            6'b001000: begin // State D
                next_Y1 = 1'b0;
                next_Y3 = 1'b0;
            end
            6'b010000: begin // State E
                next_Y1 = 1'b0;
                next_Y3 = ~w;
            end
            6'b100000: begin // State F
                next_Y1 = 1'b0;
                next_Y3 = ~w;
            end
            default: begin // Handle invalid states
                next_Y1 = 1'b0;
                next_Y3 = 1'b0;
            end
        endcase
    end

    // Output assignments
    assign Y1 = next_Y1;
    assign Y3 = next_Y3;

endmodule