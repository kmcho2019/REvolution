module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

    // Define named constants for states
    localparam STATE_A = 2'b00;
    localparam STATE_B = 2'b01;
    localparam STATE_C = 2'b10;
    localparam STATE_D = 2'b11;

    // Use case statement for next state logic
    always @(*) begin
        case (state)
            STATE_A: next_state = in? STATE_B : STATE_A;
            STATE_B: next_state = in? STATE_B : STATE_C;
            STATE_C: next_state = in? STATE_D : STATE_A;
            STATE_D: next_state = in? STATE_B : STATE_C;
            default: next_state = STATE_A;
        endcase
    end

    // Use simple logic for output
    assign out = (state == STATE_D)? 1'b1 : 1'b0;

endmodule