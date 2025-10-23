module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    always @(*) begin
        case (state)
            4'b0001: begin // State A
                if (~in) next_state = 4'b0001; // Next state is A when in=0
                else next_state = 4'b0010; // Next state is B when in=1
                out = 1'b0; // Output is 0 in state A
            end
            4'b0010: begin // State B
                next_state = 4'b0010; // Next state is B regardless of in
                out = 1'b0; // Output is 0 in state B
            end
            4'b0100: begin // State C
                if (~in) next_state = 4'b0001; // Next state is A when in=0
                else next_state = 4'b1000; // Next state is D when in=1
                out = 1'b0; // Output is 0 in state C
            end
            4'b1000: begin // State D
                if (~in) next_state = 4'b0100; // Next state is C when in=0
                else next_state = 4'b0010; // Next state is B when in=1
                out = 1'b1; // Output is 1 in state D
            end
            default: begin
                next_state = 4'b0001; // Default next state is A
                out = 1'b0; // Default output is 0
            end
        endcase
    end

endmodule