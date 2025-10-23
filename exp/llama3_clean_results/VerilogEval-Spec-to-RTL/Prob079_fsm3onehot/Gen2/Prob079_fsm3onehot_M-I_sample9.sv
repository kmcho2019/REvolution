module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Output logic
    assign out = (state == 4'b1000); // Output is 1 only when state is D

    // State transition logic using case statement
    always @(*) begin
        case (state)
            4'b0001: next_state = in? 4'b0010 : 4'b0001; // A to B when in=1, else A
            4'b0010: next_state = in? 4'b0010 : 4'b0100; // B to B when in=1, else C
            4'b0100: next_state = in? 4'b1000 : 4'b0001; // C to D when in=1, else A
            4'b1000: next_state = in? 4'b0010 : 4'b0100; // D to B when in=1, else C
            default: next_state = 4'b0000; // Default case, should not occur in one-hot encoding
        endcase
    end

endmodule