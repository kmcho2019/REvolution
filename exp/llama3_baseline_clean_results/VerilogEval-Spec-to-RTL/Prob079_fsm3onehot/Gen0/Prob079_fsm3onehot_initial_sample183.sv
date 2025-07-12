module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    always @(*) begin
        case (state)
            4'b0001: // State A
                if (!in) next_state = 4'b0001; // Next state A if in=0
                else next_state = 4'b0010; // Next state B if in=1
            4'b0010: // State B
                if (!in) next_state = 4'b0100; // Next state C if in=0
                else next_state = 4'b0010; // Next state B if in=1
            4'b0100: // State C
                if (!in) next_state = 4'b0001; // Next state A if in=0
                else next_state = 4'b1000; // Next state D if in=1
            4'b1000: // State D
                if (!in) next_state = 4'b0100; // Next state C if in=0
                else next_state = 4'b0010; // Next state B if in=1
            default: next_state = 4'b0000; // Default next state (should not occur with one-hot encoding)
        endcase

        // Output logic
        if (state == 4'b1000) // State D
            out = 1'b1;
        else
            out = 1'b0;
    end

endmodule