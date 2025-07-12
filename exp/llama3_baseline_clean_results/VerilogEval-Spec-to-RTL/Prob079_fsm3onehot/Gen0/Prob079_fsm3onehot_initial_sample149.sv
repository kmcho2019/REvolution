module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    // Output logic
    assign out = state[3]; // output is 1 when state is D (4'b1000)

    // State transition logic
    always @(*) begin
        case(state)
            4'b0001: next_state = (in) ? 4'b0010 : 4'b0001; // A -> B if in=1, else A
            4'b0010: next_state = (in) ? 4'b0010 : 4'b0100; // B -> B if in=1, else C
            4'b0100: next_state = (in) ? 4'b1000 : 4'b0001; // C -> D if in=1, else A
            4'b1000: next_state = (in) ? 4'b0010 : 4'b0100; // D -> B if in=1, else C
            default: next_state = 4'bxxxx; // default to unknown state
        endcase
    end

endmodule