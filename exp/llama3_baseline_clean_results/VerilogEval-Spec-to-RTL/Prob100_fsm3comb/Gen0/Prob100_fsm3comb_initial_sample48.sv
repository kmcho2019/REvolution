module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

    always @(*) begin
        case (state)
            2'b00: begin // State A
                next_state = in ? 2'b01 : 2'b00; // Next state is B if in=1, A if in=0
                out = 1'b0; // Output is 0 in state A
            end
            2'b01: begin // State B
                next_state = in ? 2'b01 : 2'b10; // Next state is B if in=1, C if in=0
                out = 1'b0; // Output is 0 in state B
            end
            2'b10: begin // State C
                next_state = in ? 2'b11 : 2'b00; // Next state is D if in=1, A if in=0
                out = 1'b0; // Output is 0 in state C
            end
            2'b11: begin // State D
                next_state = in ? 2'b01 : 2'b10; // Next state is B if in=1, C if in=0
                out = 1'b1; // Output is 1 in state D
            end
        endcase
    end

endmodule