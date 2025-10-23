module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

always @(state, in) begin
    case(state)
        2'b00: // State A
            if (!in)
                next_state = 2'b00; // A
            else
                next_state = 2'b01; // B
            out = 1'b0;

        2'b01: // State B
            if (!in)
                next_state = 2'b10; // C
            else
                next_state = 2'b01; // B
            out = 1'b0;

        2'b10: // State C
            if (!in)
                next_state = 2'b00; // A
            else
                next_state = 2'b11; // D
            out = 1'b0;

        2'b11: // State D
            if (!in)
                next_state = 2'b10; // C
            else
                next_state = 2'b01; // B
            out = 1'b1;

        default:
            next_state = 2'b00; // default to A
            out = 1'b0;
    endcase
end

endmodule