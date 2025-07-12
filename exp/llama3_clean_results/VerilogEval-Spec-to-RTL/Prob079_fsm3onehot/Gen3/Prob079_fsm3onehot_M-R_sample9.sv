module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

// Next state logic using case statement
always @(*) begin
    case (state)
        4'b0001: next_state = in? 4'b0010 : 4'b0001; // A -> B when in=1, A -> A when in=0
        4'b0010: next_state = in? 4'b0010 : 4'b0100; // B -> B when in=1, B -> C when in=0
        4'b0100: next_state = in? 4'b1000 : 4'b0001; // C -> D when in=1, C -> A when in=0
        4'b1000: next_state = in? 4'b0010 : 4'b0100; // D -> B when in=1, D -> C when in=0
        default: next_state = 4'b0000; // Default state
    endcase
end

// Output logic using case statement
always @(*) begin
    case (state)
        4'b1000: out = 1'b1; // Output is 1 when in state D
        default: out = 1'b0; // Output is 0 for all other states
    endcase
end

endmodule