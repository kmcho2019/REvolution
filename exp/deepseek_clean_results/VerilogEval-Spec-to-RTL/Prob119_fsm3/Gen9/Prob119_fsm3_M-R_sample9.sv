module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding using parameters for readability
    parameter [1:0] A = 2'b00,
                   B = 2'b01,
                   C = 2'b10,
                   D = 2'b11;

    reg [1:0] state, next_state;

    // Combinational next-state logic
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A; // Reset to state A
        else
            state <= next_state;
    end

    // Output logic (Moore: output depends only on state)
    assign out = (state == D); // Output 1 only in state D

endmodule