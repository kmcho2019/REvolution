module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding (A=00, B=01, C=10, D=11)
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    reg [1:0] state, next_state;

    // Next state logic - optimized case statement
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic - clear and efficient
    assign out = (state == D);

endmodule