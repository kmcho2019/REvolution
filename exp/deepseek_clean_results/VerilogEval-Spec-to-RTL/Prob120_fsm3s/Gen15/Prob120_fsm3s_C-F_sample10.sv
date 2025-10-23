module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Gray code state encoding (A=00, B=01, D=11, C=10)
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter D = 2'b11;
    parameter C = 2'b10;

    reg [1:0] current_state, next_state;

    // Next state logic
    always @(*) begin
        case (current_state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Optimized output logic - only high in state D
    assign out = (current_state == D);

endmodule