module TopModule(
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output       out
);
    // State encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000

    always @(*) begin
        // Default next_state to 0 for safety
        next_state = 4'b0000;
        case (state)
            4'b0001: begin // A
                if (in)
                    next_state = 4'b0010; // B
                else
                    next_state = 4'b0001; // A
            end
            4'b0010: begin // B
                if (in)
                    next_state = 4'b0010; // B
                else
                    next_state = 4'b0100; // C
            end
            4'b0100: begin // C
                if (in)
                    next_state = 4'b1000; // D
                else
                    next_state = 4'b0001; // A
            end
            4'b1000: begin // D
                if (in)
                    next_state = 4'b0010; // B
                else
                    next_state = 4'b0100; // C
            end
            default: begin
                next_state = 4'b0001; // Reset to A on invalid state
            end
        endcase
    end

    // Output is 1 only in state D
    assign out = state[3];

endmodule