module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding parameters
    parameter STATE_A = 2'b00;
    parameter STATE_B = 2'b01;
    parameter STATE_C = 2'b10;
    parameter STATE_D = 2'b11;

    // State registers
    reg [1:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            STATE_A: next_state = in ? STATE_B : STATE_A;  // A -> A (in=0), A -> B (in=1)
            STATE_B: next_state = in ? STATE_B : STATE_C;  // B -> C (in=0), B -> B (in=1)
            STATE_C: next_state = in ? STATE_D : STATE_A;  // C -> A (in=0), C -> D (in=1)
            STATE_D: next_state = in ? STATE_B : STATE_C;  // D -> C (in=0), D -> B (in=1)
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= STATE_A;
        else
            current_state <= next_state;
    end

    // Output logic - Moore style (depends only on current state)
    assign out = (current_state == STATE_D);  // Output 1 only in state D

endmodule