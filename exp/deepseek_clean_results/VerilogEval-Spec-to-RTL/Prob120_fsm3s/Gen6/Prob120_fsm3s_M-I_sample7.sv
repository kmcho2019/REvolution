module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // Gray code state encoding to minimize switching
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b11;
    parameter D = 2'b10;

    // State registers
    reg [1:0] current_state, next_state;

    // Next state logic using case statement
    always @(*) begin
        case (current_state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Output register (registered output breaks critical path)
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
            out <= 1'b0;
        end
        else begin
            current_state <= next_state;
            out <= (next_state == D);  // Moore output based on next state
        end
    end

endmodule