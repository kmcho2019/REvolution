module TopModule (
    input        in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output       out
);

    // State encoding for clarity
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // Next state logic: combinational case statement inside always block
    always @* begin
        case(state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A; // default safe state
        endcase
    end

    // Output logic is combinational and depends only on current state
    assign out = (state == D);

endmodule