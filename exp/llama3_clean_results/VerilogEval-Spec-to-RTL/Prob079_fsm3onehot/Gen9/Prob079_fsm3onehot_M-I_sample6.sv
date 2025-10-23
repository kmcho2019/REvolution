module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Output logic directly based on state
    assign out = state[3]; // Since out is 1 only when state is D (4'b1000)

    // State transition logic
    always @(*) begin
        case (state)
            4'b0001: next_state = in? 4'b0010 : 4'b0001; // State A
            4'b0010: next_state = in? 4'b0010 : 4'b0100; // State B
            4'b0100: next_state = in? 4'b1000 : 4'b0001; // State C
            4'b1000: next_state = in? 4'b0010 : 4'b0100; // State D
            default: next_state = 4'bxxxx;
        endcase
    end

endmodule