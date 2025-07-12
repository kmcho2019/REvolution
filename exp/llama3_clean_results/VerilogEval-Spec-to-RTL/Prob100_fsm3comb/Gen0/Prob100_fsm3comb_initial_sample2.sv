module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

    always @(*) begin
        case(state)
            2'b00: begin // State A
                if(!in) next_state = 2'b00; // Next state is A if input is 0
                else next_state = 2'b01; // Next state is B if input is 1
                out = 1'b0; // Output is 0
            end
            2'b01: begin // State B
                if(!in) next_state = 2'b10; // Next state is C if input is 0
                else next_state = 2'b01; // Next state is B if input is 1
                out = 1'b0; // Output is 0
            end
            2'b10: begin // State C
                if(!in) next_state = 2'b00; // Next state is A if input is 0
                else next_state = 2'b11; // Next state is D if input is 1
                out = 1'b0; // Output is 0
            end
            2'b11: begin // State D
                if(!in) next_state = 2'b10; // Next state is C if input is 0
                else next_state = 2'b01; // Next state is B if input is 1
                out = 1'b1; // Output is 1
            end
            default: begin
                next_state = 2'b00; // Default next state is A
                out = 1'b0; // Default output is 0
            end
        endcase
    end

endmodule