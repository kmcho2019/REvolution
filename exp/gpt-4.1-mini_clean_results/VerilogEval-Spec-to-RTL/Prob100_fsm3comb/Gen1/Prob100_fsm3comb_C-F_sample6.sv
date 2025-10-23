module TopModule(
    input       in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

    // State encoding
    localparam A = 2'b00,
               B = 2'b01,
               C = 2'b10,
               D = 2'b11;

    always @(*) begin
        // Output depends only on current state (Moore machine)
        out = (state == D) ? 1'b1 : 1'b0;

        // Next state logic
        case(state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A; // Safe default
        endcase
    end

endmodule