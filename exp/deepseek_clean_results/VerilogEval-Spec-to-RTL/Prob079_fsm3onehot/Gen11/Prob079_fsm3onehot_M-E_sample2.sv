module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    always @(*) begin
        case (1'b1)  // Priority encoder style for one-hot states
            state[0]: next_state = in ? 4'b0010 : 4'b0001; // A -> B if in=1, else A
            state[1]: next_state = in ? 4'b0010 : 4'b0100; // B -> B if in=1, else C
            state[2]: next_state = in ? 4'b1000 : 4'b0001;  // C -> D if in=1, else A
            state[3]: next_state = in ? 4'b0010 : 4'b0100;  // D -> B if in=1, else C
            default:  next_state = 4'b0001;                // Default to A
        endcase
    end

    assign out = state[3];  // Output is 1 only in state D

endmodule