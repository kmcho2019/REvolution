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

    // Combinational logic block for next_state
    always @(*) begin
        case (state)
            A: next_state = (in) ? B : A;
            B: next_state = (in) ? B : C;
            C: next_state = (in) ? D : A;
            D: next_state = (in) ? B : C;
            default: next_state = A;
        endcase
    end

    // Moore output logic: output is high only in state D
    assign out = (state == D);

endmodule