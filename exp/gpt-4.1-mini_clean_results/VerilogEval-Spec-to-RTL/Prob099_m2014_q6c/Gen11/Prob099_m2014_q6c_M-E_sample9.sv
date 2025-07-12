module TopModule (
    input  [5:0] y, // one-hot current state vector: y[0]=A, y[1]=B, ..., y[5]=F
    input        w,
    output       Y2, // corresponds to y[1] next state (B)
    output       Y4  // corresponds to y[3] next state (D)
);

wire [5:0] next_state;

reg [5:0] next_state_r;

always @(*) begin
    // Default no next state
    next_state_r = 6'b0;

    case (1'b1) // case on which state y is asserted (only one bit set)
        y[0]: begin // State A
            if (w == 1'b0)
                next_state_r[1] = 1'b1; // B
            else
                next_state_r[0] = 1'b1; // A
        end
        y[1]: begin // State B
            if (w == 1'b0)
                next_state_r[2] = 1'b1; // C
            else
                next_state_r[3] = 1'b1; // D
        end
        y[2]: begin // State C
            if (w == 1'b0)
                next_state_r[4] = 1'b1; // E
            else
                next_state_r[3] = 1'b1; // D
        end
        y[3]: begin // State D
            if (w == 1'b0)
                next_state_r[5] = 1'b1; // F
            else
                next_state_r[0] = 1'b1; // A
        end
        y[4]: begin // State E
            if (w == 1'b0)
                next_state_r[4] = 1'b1; // E
            else
                next_state_r[3] = 1'b1; // D
        end
        y[5]: begin // State F
            if (w == 1'b0)
                next_state_r[2] = 1'b1; // C
            else
                next_state_r[3] = 1'b1; // D
        end
        default: begin
            next_state_r = 6'b0; // no valid state active
        end
    endcase
end

assign next_state = next_state_r;

// Outputs are the bits corresponding to states B (y[1]) and D (y[3]) in next_state
assign Y2 = next_state[1];
assign Y4 = next_state[3];

endmodule