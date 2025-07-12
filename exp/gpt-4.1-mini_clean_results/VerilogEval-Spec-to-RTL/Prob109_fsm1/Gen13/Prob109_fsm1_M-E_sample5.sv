module TopModule (
    input        clk,
    input        areset,
    input        in,
    output reg   out
);

    // One-hot state encoding: B = 2'b10, A = 2'b01
    reg [1:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            2'b10: // State B
                next_state = in ? 2'b10 : 2'b01; // B->B on 1, B->A on 0
            2'b01: // State A
                next_state = in ? 2'b01 : 2'b10; // A->A on 1, A->B on 0
            default:
                next_state = 2'b10; // Safety: default to state B
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b10; // Initialize to state B
        else
            state <= next_state;
    end

    // Output logic: out=1 when in state B (2'b10), else 0
    always @(*) begin
        out = (state == 2'b10) ? 1'b1 : 1'b0;
    end

endmodule