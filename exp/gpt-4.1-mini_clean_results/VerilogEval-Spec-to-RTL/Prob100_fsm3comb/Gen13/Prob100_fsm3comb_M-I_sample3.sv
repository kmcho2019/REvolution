module TopModule (
    input        in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output       out
);

    // State encoding
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // Next state combinational logic using always_comb with case statement for clarity and improved synthesis
    always @(*) begin
        case(state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Moore output depends only on the current state (state D outputs 1)
    assign out = (state == D);

endmodule