module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output       out
);

    always @* begin
        case (state)
            4'b0001: begin // State A
                if (in)
                    next_state = 4'b0010; // B
                else
                    next_state = 4'b0001; // A
            end
            4'b0010: begin // State B
                if (in)
                    next_state = 4'b0010; // B
                else
                    next_state = 4'b0100; // C
            end
            4'b0100: begin // State C
                if (in)
                    next_state = 4'b1000; // D
                else
                    next_state = 4'b0001; // A
            end
            4'b1000: begin // State D
                if (in)
                    next_state = 4'b0010; // B
                else
                    next_state = 4'b0100; // C
            end
            default: begin
                next_state = 4'b0001; // Default to A on invalid state
            end
        endcase
    end

    // Output is 1 only in state D
    assign out = state[3];

endmodule