module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Parameterized state encoding for clarity
    parameter [1:0] A = 2'b00;
    parameter [1:0] B = 2'b01;
    parameter [1:0] C = 2'b10;
    parameter [1:0] D = 2'b11;

    // State registers
    reg [1:0] current_state, next_state;

    // Combinational next-state logic
    always @(*) begin
        case (current_state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
    end

    // Optimized output logic - only high when in state D
    assign out = (current_state == D);

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

endmodule