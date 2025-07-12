module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    always @(*) begin
        next_state = 4'b0000; // Initialize with an invalid state to avoid latches
        out = 1'b0; // Default output value
        
        case (state)
            4'b0001: // State A
                if (!in) next_state = 4'b0001; // Stay in A if in=0
                else next_state = 4'b0010; // Move to B if in=1
            4'b0010: // State B
                if (!in) next_state = 4'b0100; // Move to C if in=0
                else next_state = 4'b0010; // Stay in B if in=1
            4'b0100: // State C
                if (!in) next_state = 4'b0001; // Move to A if in=0
                else next_state = 4'b1000; // Move to D if in=1
            4'b1000: // State D
                if (!in) next_state = 4'b0100; // Move to C if in=0
                else next_state = 4'b0010; // Move to B if in=1
        endcase
        
        // Output logic
        if (state == 4'b1000) // State D
            out = 1'b1;
        else // States A, B, C
            out = 1'b0;
    end

endmodule