module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

// Implement next state logic
always @(*) begin
    case (state)
        4'b0001: // State A
            next_state = in? 4'b0010 : 4'b0001; // in=1 goes to B, in=0 stays in A
        4'b0010: // State B
            next_state = in? 4'b0010 : 4'b0100; // in=1 stays in B, in=0 goes to C
        4'b0100: // State C
            next_state = in? 4'b1000 : 4'b0001; // in=1 goes to D, in=0 goes to A
        4'b1000: // State D
            next_state = in? 4'b0010 : 4'b0100; // in=1 goes to B, in=0 goes to C
        default:
            next_state = 4'b0001; // Default to state A if none of the above conditions match
    endcase
end

// Implement output logic
always @(*) begin
    case (state)
        4'b0001, 4'b0010, 4'b0100: // States A, B, C
            out = 1'b0;
        4'b1000: // State D
            out = 1'b1;
        default:
            out = 1'b0; // Default output to 0 if none of the above conditions match
    endcase
end

endmodule