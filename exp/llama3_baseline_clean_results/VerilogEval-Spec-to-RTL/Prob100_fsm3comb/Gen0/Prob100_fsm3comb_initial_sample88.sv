module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

always @(*) begin
    case(state)
        2'b00: // A
            begin
                if (~in)
                    next_state = 2'b00; // A
                else
                    next_state = 2'b01; // B
                out = 1'b0;
            end
        2'b01: // B
            begin
                if (~in)
                    next_state = 2'b10; // C
                else
                    next_state = 2'b01; // B
                out = 1'b0;
            end
        2'b10: // C
            begin
                if (~in)
                    next_state = 2'b00; // A
                else
                    next_state = 2'b11; // D
                out = 1'b0;
            end
        2'b11: // D
            begin
                if (~in)
                    next_state = 2'b10; // C
                else
                    next_state = 2'b01; // B
                out = 1'b1;
            end
        default:
            next_state = 2'b00; // default to state A
            out = 1'b0;
    endcase
end

endmodule