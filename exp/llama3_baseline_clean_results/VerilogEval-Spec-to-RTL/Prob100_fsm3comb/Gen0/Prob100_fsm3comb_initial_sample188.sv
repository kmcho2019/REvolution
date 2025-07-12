module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

always @(*)
begin
    case(state)
        2'b00: // State A
        begin
            if (~in) next_state = 2'b00; // in=0, next state is A
            else next_state = 2'b01; // in=1, next state is B
            out = 1'b0; // output is always 0 in state A
        end
        2'b01: // State B
        begin
            if (~in) next_state = 2'b10; // in=0, next state is C
            else next_state = 2'b01; // in=1, next state is B
            out = 1'b0; // output is always 0 in state B
        end
        2'b10: // State C
        begin
            if (~in) next_state = 2'b00; // in=0, next state is A
            else next_state = 2'b11; // in=1, next state is D
            out = 1'b0; // output is always 0 in state C
        end
        2'b11: // State D
        begin
            if (~in) next_state = 2'b10; // in=0, next state is C
            else next_state = 2'b01; // in=1, next state is B
            out = 1'b1; // output is always 1 in state D
        end
        default:
        begin
            next_state = 2'b00; // default next state is A
            out = 1'b0; // default output is 0
        end
    endcase
end
endmodule