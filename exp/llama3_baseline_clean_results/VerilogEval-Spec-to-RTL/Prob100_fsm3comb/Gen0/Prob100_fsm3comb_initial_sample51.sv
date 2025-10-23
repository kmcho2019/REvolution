module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

    // State transition logic
    always @(state, in) begin
        case (state)
            2'b00: // State A
                if (!in) next_state = 2'b00;
                else next_state = 2'b01;
            2'b01: // State B
                if (!in) next_state = 2'b10;
                else next_state = 2'b01;
            2'b10: // State C
                if (!in) next_state = 2'b00;
                else next_state = 2'b11;
            2'b11: // State D
                if (!in) next_state = 2'b10;
                else next_state = 2'b01;
            default: next_state = 2'b00; // default state
        endcase
    end

    // Output logic
    always @(state) begin
        case (state)
            2'b00, 2'b01, 2'b10: out = 1'b0;
            2'b11: out = 1'b1;
            default: out = 1'b0; // default output
        endcase
    end

endmodule