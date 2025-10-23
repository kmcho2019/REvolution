module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Binary state encoding (A=00, B=01, C=10, D=11)
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    reg [1:0] current_state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (current_state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;  // Safe default
        endcase
    end

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic - Moore style (only depends on current state)
    assign out = (current_state == D);  // Only high in state D

endmodule