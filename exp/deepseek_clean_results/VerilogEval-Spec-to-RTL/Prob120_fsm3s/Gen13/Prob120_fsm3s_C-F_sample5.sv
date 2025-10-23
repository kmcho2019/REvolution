module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Gray code state encoding to minimize transitions
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter D = 2'b11;
    parameter C = 2'b10;

    // State registers
    reg [1:0] current_state, next_state;

    // Next state logic using case statement
    always @(*) begin
        case (current_state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A; // Safe default
        endcase
    end

    // Optimized output logic - direct state comparison
    assign out = (current_state == D);

    // State register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

endmodule