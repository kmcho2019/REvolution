module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // Define states
    localparam STATE_0 = 3'd0;
    localparam STATE_1 = 3'd1;
    localparam STATE_2 = 3'd2;
    localparam STATE_3 = 3'd3;
    localparam STATE_4 = 3'd4;
    localparam STATE_5 = 3'd5;
    localparam STATE_6 = 3'd6;
    localparam STATE_ERR = 3'd7;

    reg [2:0] current_state, next_state;
    reg disc_reg, flag_reg, err_reg;

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

    // Output logic (Moore FSM - outputs depend only on current state)
    always @(*) begin
        disc_reg = 0;
        flag_reg = 0;
        err_reg = 0;
        
        case (current_state)
            STATE_5: disc_reg = ~in;  // After 5 1s, if next is 0
            STATE_6: flag_reg = ~in;  // After 6 1s, if next is 0
            STATE_ERR: err_reg = 1;   // Any time in error state
            default: begin
                disc_reg = 0;
                flag_reg = 0;
                err_reg = 0;
            end
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

    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule