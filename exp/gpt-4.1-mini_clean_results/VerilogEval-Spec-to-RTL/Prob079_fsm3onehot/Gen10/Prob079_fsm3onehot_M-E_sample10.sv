module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output reg       out
);

    always @(*) begin
        // Default assignments to avoid latches
        next_state = 4'b0000;
        out = 1'b0;
        case (state)
            4'b0001: begin // State A
                out = 1'b0;
                if (in == 1'b0)
                    next_state = 4'b0001; // Stay in A
                else
                    next_state = 4'b0010; // Go to B
            end
            4'b0010: begin // State B
                out = 1'b0;
                if (in == 1'b0)
                    next_state = 4'b0100; // Go to C
                else
                    next_state = 4'b0010; // Stay in B
            end
            4'b0100: begin // State C
                out = 1'b0;
                if (in == 1'b0)
                    next_state = 4'b0001; // Go to A
                else
                    next_state = 4'b1000; // Go to D
            end
            4'b1000: begin // State D
                out = 1'b1;
                if (in == 1'b0)
                    next_state = 4'b0100; // Go to C
                else
                    next_state = 4'b0010; // Go to B
            end
            default: begin
                // If no valid one-hot state, default to A and output 0
                next_state = 4'b0001;
                out = 1'b0;
            end
        endcase
    end

endmodule