module TopModule (
    input        in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output       out
);

    // State encoding using localparams for clarity
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // Next state combinational logic implemented with a case statement for synthesis friendliness and clarity
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A; // Defensive default to state A
        endcase
    end

    // Moore output depends only on the current state
    assign out = (state == D);

endmodule