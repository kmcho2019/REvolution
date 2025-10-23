module TopModule (
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

always @(state, in) begin
    case (state)
        2'b00: // State A
            begin
                if (!in) begin
                    next_state = 2'b00; // Next state A
                end else begin
                    next_state = 2'b01; // Next state B
                end
                out = 1'b0;
            end
        2'b01: // State B
            begin
                if (!in) begin
                    next_state = 2'b10; // Next state C
                end else begin
                    next_state = 2'b01; // Next state B
                end
                out = 1'b0;
            end
        2'b10: // State C
            begin
                if (!in) begin
                    next_state = 2'b00; // Next state A
                end else begin
                    next_state = 2'b11; // Next state D
                end
                out = 1'b0;
            end
        2'b11: // State D
            begin
                if (!in) begin
                    next_state = 2'b10; // Next state C
                end else begin
                    next_state = 2'b01; // Next state B
                end
                out = 1'b1;
            end
        default:
            begin
                next_state = 2'b00; // Default next state A
                out = 1'b0;
            end
    endcase
end

endmodule