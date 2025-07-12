module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding
    wire [3:0] A = 4'b0001;
    wire [3:0] B = 4'b0010;
    wire [3:0] C = 4'b0100;
    wire [3:0] D = 4'b1000;

    // Define next state based on input condition
    reg [3:0] next_state_reg;
    always @(*) begin
        case (state)
            A: next_state_reg = in? B : A;
            B: next_state_reg = in? B : C;
            C: next_state_reg = in? D : A;
            D: next_state_reg = in? B : C;
            default: next_state_reg = 4'bxxxx;
        endcase
    end

    assign next_state = next_state_reg;

    // Output logic using one-hot state encoding property
    assign out = state[3];

endmodule