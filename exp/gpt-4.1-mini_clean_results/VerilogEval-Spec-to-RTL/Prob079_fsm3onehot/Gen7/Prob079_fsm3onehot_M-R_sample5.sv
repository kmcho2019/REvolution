module TopModule(
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output       out
);
    // State encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000

    always @(*) begin
        casez (state)
            4'b0001: // A
                if (in == 1'b0)
                    next_state = 4'b0001; // A
                else
                    next_state = 4'b0010; // B
            4'b0010: // B
                if (in == 1'b0)
                    next_state = 4'b0100; // C
                else
                    next_state = 4'b0010; // B
            4'b0100: // C
                if (in == 1'b0)
                    next_state = 4'b0001; // A
                else
                    next_state = 4'b1000; // D
            4'b1000: // D
                if (in == 1'b0)
                    next_state = 4'b0100; // C
                else
                    next_state = 4'b0010; // B
            default:
                next_state = 4'b0000; // safe default (no state)
        endcase
    end

    // Output is '1' only in state D
    assign out = state[3];

endmodule