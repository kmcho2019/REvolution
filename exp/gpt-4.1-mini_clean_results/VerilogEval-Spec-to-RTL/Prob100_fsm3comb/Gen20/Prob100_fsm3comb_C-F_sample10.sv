module TopModule (
    input        in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output       out
);

    // State encoding using localparams for readability and maintainability
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // Combinational next_state logic with clear case statement and default case for safety
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A; // Defensive fallback to avoid latches
        endcase
    end

    // Output logic as a continuous assignment based on current state,
    // output high only in state D, improving synthesis clarity and minimizing logic
    assign out = (state == D);

endmodule