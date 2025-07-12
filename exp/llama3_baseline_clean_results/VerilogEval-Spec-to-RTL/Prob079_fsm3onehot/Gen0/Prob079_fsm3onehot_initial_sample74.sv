module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    // Output logic (Moore machine, output depends only on the current state)
    assign out = state[3]; // Output is 1 only when in state D

    // State transition logic
    always @(*) begin
        case(state)
            4'b0001: next_state = in ? 4'b0010 : 4'b0001; // A
            4'b0010: next_state = in ? 4'b0010 : 4'b0100; // B
            4'b0100: next_state = in ? 4'b1000 : 4'b0001; // C
            4'b1000: next_state = in ? 4'b0010 : 4'b0100; // D
            default: next_state = 4'bxxxx; // Default to prevent latches, but in a real implementation, handle undefined states properly
        endcase
    end

endmodule