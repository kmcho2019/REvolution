module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // Output is simply the D state bit (Moore machine)
    assign out = state[3];

    // LUT-style state transition implementation
    always @(*) begin
        case ({state, in})
            5'b0001_0: next_state = 4'b0001; // A, in=0 → A
            5'b0001_1: next_state = 4'b0010; // A, in=1 → B
            5'b0010_0: next_state = 4'b0100; // B, in=0 → C
            5'b0010_1: next_state = 4'b0010; // B, in=1 → B
            5'b0100_0: next_state = 4'b0001; // C, in=0 → A
            5'b0100_1: next_state = 4'b1000; // C, in=1 → D
            5'b1000_0: next_state = 4'b0100; // D, in=0 → C
            5'b1000_1: next_state = 4'b0010; // D, in=1 → B
            default:   next_state = 4'b0001; // Invalid states go to A
        endcase
    end

endmodule