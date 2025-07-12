module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output       out
);

    // Output logic: out = 1 when in state D (1000)
    assign out = state[3];

    always @(*) begin
        casez(state)
            4'b0001:  // A
                next_state = in ? 4'b0010 : 4'b0001;  // B or A
            4'b0010:  // B
                next_state = in ? 4'b0010 : 4'b0100;  // B or C
            4'b0100:  // C
                next_state = in ? 4'b1000 : 4'b0001;  // D or A
            4'b1000:  // D
                next_state = in ? 4'b0010 : 4'b0100;  // B or C
            default:
                next_state = 4'b0000;  // Undefined state, no next state
        endcase
    end

endmodule