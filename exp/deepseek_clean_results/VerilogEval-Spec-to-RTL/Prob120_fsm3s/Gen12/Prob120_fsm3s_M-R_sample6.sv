module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding parameters
    parameter [1:0] S_A = 2'b00;
    parameter [1:0] S_B = 2'b01;
    parameter [1:0] S_C = 2'b10;
    parameter [1:0] S_D = 2'b11;

    reg [1:0] current_state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (current_state)
            S_A: next_state = in ? S_B : S_A;
            S_B: next_state = in ? S_B : S_C;
            S_C: next_state = in ? S_D : S_A;
            S_D: next_state = in ? S_B : S_C;
            default: next_state = S_A;  // Safe default
        endcase
    end

    // Sequential state storage
    always @(posedge clk) begin
        if (reset)
            current_state <= S_A;
        else
            current_state <= next_state;
    end

    // Output logic (combinational)
    assign out = (current_state == S_D);

endmodule