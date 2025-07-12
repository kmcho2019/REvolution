module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Output logic
    assign out = (state == 4'b1000); // Output is 1 when state is D, 0 otherwise

    // State transition logic
    always @(*) begin
        case(state)
            4'b0001: next_state = (in) ? 4'b0010 : 4'b0001; // A -> B when in=1, A when in=0
            4'b0010: next_state = (in) ? 4'b0010 : 4'b0100; // B -> B when in=1, C when in=0
            4'b0100: next_state = (in) ? 4'b1000 : 4'b0001; // C -> D when in=1, A when in=0
            4'b1000: next_state = (in) ? 4'b0010 : 4'b0100; // D -> B when in=1, C when in=0
            default: next_state = 4'b0000; // Invalid state, assign next_state to 0
        endcase
    end

endmodule