module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // Gray state encoding (A=00, B=01, C=11, D=10)
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b11;
    parameter D = 2'b10;
    
    reg [1:0] state, next_state;

    // Next state logic using optimized case statement
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;  // A -> B or A
            B: next_state = in ? B : C;  // B -> B or C
            C: next_state = in ? D : A;  // C -> D or A
            D: next_state = in ? B : C;  // D -> B or C
            default: next_state = A;     // Handle unexpected states
        endcase
    end

    // State register with synchronous reset and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;  // Reset to state A
            out <= 1'b0;
        end
        else begin
            state <= next_state;
            // Output is high only in state D
            out <= (next_state == D);
        end
    end

endmodule