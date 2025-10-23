module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    // Output logic: out is 1 only when state is D (4'b1000)
    assign out = state[3];  // Since D is represented by 4'b1000, out will be 1 only when state[3] is 1

    // Next state logic
    always @(*) begin
        case(state)
            4'b0001: next_state = (in == 0)? 4'b0001 : 4'b0010;  // From A, move to A if in=0, to B if in=1
            4'b0010: next_state = (in == 0)? 4'b0100 : 4'b0010;  // From B, move to C if in=0, to B if in=1
            4'b0100: next_state = (in == 0)? 4'b0001 : 4'b1000;  // From C, move to A if in=0, to D if in=1
            4'b1000: next_state = (in == 0)? 4'b0100 : 4'b0010;  // From D, move to C if in=0, to B if in=1
            default: next_state = 4'b0000;  // Default next state if current state is not recognized
        endcase
    end

endmodule