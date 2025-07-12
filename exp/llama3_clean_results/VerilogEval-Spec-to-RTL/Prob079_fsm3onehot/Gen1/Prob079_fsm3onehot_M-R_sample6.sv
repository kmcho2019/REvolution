module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // output logic
    assign out = state[3];  // Output is 1 only if state is D

    // next state logic using case statement
    always @(*) begin
        case (1'b1)
            state[0]: next_state = in ? 4'b0010 : 4'b0001;  // State A
            state[1]: next_state = in ? 4'b0010 : 4'b0100;  // State B
            state[2]: next_state = in ? 4'b1000 : 4'b0001;  // State C
            state[3]: next_state = in ? 4'b0010 : 4'b0100;  // State D
            default: next_state = 4'bxxxx;  // Handle invalid state
        endcase
    end

endmodule