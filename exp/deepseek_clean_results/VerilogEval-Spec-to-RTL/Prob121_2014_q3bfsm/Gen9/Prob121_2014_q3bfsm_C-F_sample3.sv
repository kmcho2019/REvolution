module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // Descriptive state encoding parameters
    parameter STATE_0 = 3'b000;  // Initial state
    parameter STATE_1 = 3'b001;
    parameter STATE_2 = 3'b010;
    parameter STATE_3 = 3'b011;  // Output z=1
    parameter STATE_4 = 3'b100;  // Output z=1

    reg [2:0] current_state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= STATE_0;
        else
            current_state <= next_state;
    end

    // Next state logic - clear case statement approach
    always @(*) begin
        case (current_state)
            STATE_0: next_state = x ? STATE_1 : STATE_0;
            STATE_1: next_state = x ? STATE_4 : STATE_1;
            STATE_2: next_state = x ? STATE_1 : STATE_2;
            STATE_3: next_state = x ? STATE_2 : STATE_1;
            STATE_4: next_state = x ? STATE_4 : STATE_3;
        endcase
    end

    // Output logic - z=1 only in STATE_3 or STATE_4
    assign z = (current_state == STATE_3) || (current_state == STATE_4);

endmodule