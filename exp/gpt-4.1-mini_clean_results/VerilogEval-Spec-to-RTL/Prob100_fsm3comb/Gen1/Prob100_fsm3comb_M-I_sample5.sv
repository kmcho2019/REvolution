module TopModule(
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    // Output logic: out is 1 only in state D
    assign out = (state == D);

    // Next state logic
    reg [1:0] next_state_reg;
    always @(*) begin
        case (state)
            A: next_state_reg = (in == 1'b0) ? A : B;
            B: next_state_reg = (in == 1'b0) ? C : B;
            C: next_state_reg = (in == 1'b0) ? A : D;
            D: next_state_reg = (in == 1'b0) ? C : B;
            default: next_state_reg = A;
        endcase
    end

    assign next_state = next_state_reg;

endmodule