module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

always @(*) begin
    case(state)
        2'b00: begin // State A
            if (~in) begin
                next_state = 2'b00; // Next state is A when in=0
            end else begin
                next_state = 2'b01; // Next state is B when in=1
            end
            out = 1'b0; // Output is 0
        end

        2'b01: begin // State B
            next_state = in ? 2'b01 : 2'b10; // Next state is B when in=1, C when in=0
            out = 1'b0; // Output is 0
        end

        2'b10: begin // State C
            next_state = in ? 2'b11 : 2'b00; // Next state is D when in=1, A when in=0
            out = 1'b0; // Output is 0
        end

        2'b11: begin // State D
            next_state = in ? 2'b01 : 2'b10; // Next state is B when in=1, C when in=0
            out = 1'b1; // Output is 1
        end

        default: begin
            next_state = 2'b00; // Default next state is A
            out = 1'b0; // Default output is 0
        end
    endcase
end

endmodule