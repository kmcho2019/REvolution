module TopModule (
    input        in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output       out
);

    // State encoding parameters
    localparam [1:0] A = 2'b00,
                     B = 2'b01,
                     C = 2'b10,
                     D = 2'b11;

    // Next state combinational logic using always @* and case statement for clarity
    always @* begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A; // safe default state
        endcase
    end

    // Moore output logic: output 1 only when in state D (2'b11)
    // Use bitwise AND of state bits for minimal logic
    assign out = state[1] & state[0];

endmodule