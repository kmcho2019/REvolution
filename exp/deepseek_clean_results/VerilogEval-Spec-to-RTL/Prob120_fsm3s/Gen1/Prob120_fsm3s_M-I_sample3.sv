module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Gray-coded state encoding to minimize transitions
    parameter [1:0] A = 2'b00;
    parameter [1:0] B = 2'b01;
    parameter [1:0] C = 2'b11;
    parameter [1:0] D = 2'b10;

    // State register
    reg [1:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
    end

    // Output is MSB when in state D (D is 2'b10)
    assign out = current_state[1] & ~current_state[0];

    // State register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

endmodule