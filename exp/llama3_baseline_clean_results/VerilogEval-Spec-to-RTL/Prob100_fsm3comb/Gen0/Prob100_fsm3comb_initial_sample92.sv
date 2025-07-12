module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

    always_comb begin
        case (state)
            2'b00: // State A
                next_state = in ? 2'b01 : 2'b00;
            2'b01: // State B
                next_state = in ? 2'b01 : 2'b10;
            2'b10: // State C
                next_state = in ? 2'b11 : 2'b00;
            2'b11: // State D
                next_state = in ? 2'b01 : 2'b10;
            default:
                next_state = 2'b00; // default to state A for invalid states
        endcase

        // Output logic based on current state
        case (state)
            2'b11: // State D
                out = 1'b1;
            default:
                out = 1'b0;
        endcase
    end

endmodule