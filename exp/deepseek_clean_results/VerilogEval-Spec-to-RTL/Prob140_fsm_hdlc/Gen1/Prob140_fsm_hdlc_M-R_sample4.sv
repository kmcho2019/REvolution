module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Define states
    localparam STATE_0    = 3'd0;
    localparam STATE_1    = 3'd1;
    localparam STATE_2    = 3'd2;
    localparam STATE_3    = 3'd3;
    localparam STATE_4    = 3'd4;
    localparam STATE_5    = 3'd5;
    localparam STATE_DISC = 3'd6;
    localparam STATE_FLAG = 3'd7;

    reg [2:0] current_state, next_state;
    reg disc_next, flag_next, err_next;

    // State transition logic
    always @(*) begin
        next_state = current_state;
        disc_next = 0;
        flag_next = 0;
        err_next = 0;

        case (current_state)
            STATE_0: next_state = in ? STATE_1 : STATE_0;
            STATE_1: next_state = in ? STATE_2 : STATE_0;
            STATE_2: next_state = in ? STATE_3 : STATE_0;
            STATE_3: next_state = in ? STATE_4 : STATE_0;
            STATE_4: next_state = in ? STATE_5 : STATE_0;
            STATE_5: begin
                if (in) 
                    next_state = STATE_FLAG;
                else 
                    next_state = STATE_DISC;
            end
            STATE_FLAG: begin
                if (in)
                    err_next = 1;
                next_state = in ? STATE_ERR : STATE_0;
            end
            STATE_DISC: begin
                disc_next = 1;
                next_state = STATE_0;
            end
            default: next_state = STATE_0; // STATE_ERR and others
        endcase

        // Handle error state
        if (current_state == STATE_FLAG && in)
            err_next = 1;
    end

    // State and output registers
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            current_state <= next_state;
            disc <= disc_next;
            flag <= (current_state == STATE_FLAG) && !in;
            err <= err_next;
        end
    end

endmodule