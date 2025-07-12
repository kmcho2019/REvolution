module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// next state logic
always @(state, in) begin
    case (state)
        4'b0001: // state A
            if (~in) begin
                next_state = 4'b0001; // next state A
            end else begin
                next_state = 4'b0010; // next state B
            end
        4'b0010: // state B
            if (~in) begin
                next_state = 4'b0100; // next state C
            end else begin
                next_state = 4'b0010; // next state B
            end
        4'b0100: // state C
            if (~in) begin
                next_state = 4'b0001; // next state A
            end else begin
                next_state = 4'b1000; // next state D
            end
        4'b1000: // state D
            if (~in) begin
                next_state = 4'b0100; // next state C
            end else begin
                next_state = 4'b0010; // next state B
            end
        default: // invalid state
            next_state = 4'b0000; // reset to state A
    endcase
end

// output logic
always @(state) begin
    case (state)
        4'b1000: // state D
            out = 1'b1; // output is 1
        default: // all other states
            out = 1'b0; // output is 0
    endcase
end

endmodule