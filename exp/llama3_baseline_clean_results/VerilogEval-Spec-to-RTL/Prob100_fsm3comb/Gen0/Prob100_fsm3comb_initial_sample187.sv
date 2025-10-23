module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

always @(*) begin
    case (state)
        2'b00: // State A
            if (~in)
                next_state = 2'b00;
            else
                next_state = 2'b01;
            out = 1'b0;

        2'b01: // State B
            if (~in)
                next_state = 2'b10;
            else
                next_state = 2'b01;
            out = 1'b0;

        2'b10: // State C
            if (~in)
                next_state = 2'b00;
            else
                next_state = 2'b11;
            out = 1'b0;

        2'b11: // State D
            if (~in)
                next_state = 2'b10;
            else
                next_state = 2'b01;
            out = 1'b1;

        default: // Invalid state
            next_state = 2'b00; // Reset to state A
            out = 1'b0;
    endcase
end

endmodule