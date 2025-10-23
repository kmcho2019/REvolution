module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // Define states
    localparam STATE_0   = 3'd0;
    localparam STATE_1   = 3'd1;
    localparam STATE_2   = 3'd2;
    localparam STATE_3   = 3'd3;
    localparam STATE_4   = 3'd4;
    localparam STATE_5   = 3'd5;
    localparam STATE_6   = 3'd6;
    localparam STATE_ERR = 3'd7;

    reg [2:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            STATE_0: next_state = in ? STATE_1 : STATE_0;
            STATE_1: next_state = in ? STATE_2 : STATE_0;
            STATE_2: next_state = in ? STATE_3 : STATE_0;
            STATE_3: next_state = in ? STATE_4 : STATE_0;
            STATE_4: next_state = in ? STATE_5 : STATE_0;
            STATE_5: next_state = in ? STATE_6 : STATE_0;
            STATE_6: next_state = in ? STATE_ERR : STATE_0;
            STATE_ERR: next_state = in ? STATE_ERR : STATE_0;
            default: next_state = STATE_0;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_0;
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic (Moore FSM - outputs depend only on current state)
    assign disc = (current_state == STATE_5) && in;
    assign flag = (current_state == STATE_6) && !in;
    assign err = (current_state == STATE_ERR);

endmodule