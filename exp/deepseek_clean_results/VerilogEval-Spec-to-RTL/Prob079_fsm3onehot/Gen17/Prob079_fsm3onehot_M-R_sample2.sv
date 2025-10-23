module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // State definitions (one-hot encoding)
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // Combinational state transition logic
    always_comb begin
        casez (state)
            A: next_state = in ? B : A;    // A -> B if in=1, else stay
            B: next_state = in ? B : C;    // B -> C if in=0, else stay
            C: next_state = in ? D : A;    // C -> D if in=1, else -> A
            D: next_state = in ? B : C;    // D -> B if in=1, else -> C
            default: next_state = A;       // Handle undefined states
        endcase
    end

    // Moore output (high only in state D)
    assign out = state[3];

endmodule