module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

    always @(*) begin
        // Determine next state based on current state and input
        case(state)
            2'b00: next_state = (in) ? 2'b01 : 2'b00;
            2'b01: next_state = (in) ? 2'b01 : 2'b10;
            2'b10: next_state = (in) ? 2'b11 : 2'b00;
            2'b11: next_state = (in) ? 2'b01 : 2'b10;
        endcase

        // Determine output based on current state
        case(state)
            2'b00, 2'b01, 2'b10: out = 1'b0;
            2'b11: out = 1'b1;
        endcase
    end

endmodule