module TopModule (
    input        in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output       out
);

    // State encoding for clarity and easy modifications
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // Next state logic implemented in a combinational always block with a case statement
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Moore output logic as a continuous assignment for minimal logic and easy synthesis
    assign out = (state == D);

endmodule