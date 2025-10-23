module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // State transition logic using case statement
    always @(*) begin
        case (1'b1)  // Synthesis will recognize this as one-hot case
            state[0]: next_state = in ? 4'b0010 : 4'b0001; // A -> B if in=1, else A
            state[1]: next_state = in ? 4'b0010 : 4'b0100; // B -> B if in=1, else C
            state[2]: next_state = in ? 4'b1000 : 4'b0001; // C -> D if in=1, else A
            state[3]: next_state = in ? 4'b0010 : 4'b0100; // D -> B if in=1, else C
            default:  next_state = 4'b0001;              // Default to state A
        endcase
    end

    // Output logic remains the same
    assign out = state[3];

endmodule