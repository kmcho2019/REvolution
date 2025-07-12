module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Define states with proper encoding
    localparam STATE_0        = 4'd0;
    localparam STATE_1        = 4'd1;
    localparam STATE_2        = 4'd2;
    localparam STATE_3        = 4'd3;
    localparam STATE_4        = 4'd4;
    localparam STATE_5        = 4'd5;
    localparam STATE_DISC     = 4'd6;
    localparam STATE_FLAG     = 4'd7;
    localparam STATE_FLAG_DONE = 4'd8;
    localparam STATE_ERR      = 4'd9;

    reg [3:0] current_state, next_state;
    reg disc_next, flag_next, err_next;

    // State transition logic (combinational)
    always @(*) begin
        next_state = current_state;
        disc_next = 0;
        flag_next = 0;
        err_next = 0;

        case (current_state)
            STATE_0:    next_state = in ? STATE_1 : STATE_0;
            STATE_1:    next_state = in ? STATE_2 : STATE_0;
            STATE_2:    next_state = in ? STATE_3 : STATE_0;
            STATE_3:    next_state = in ? STATE_4 : STATE_0;
            STATE_4:    next_state = in ? STATE_5 : STATE_0;
            STATE_5:    next_state = in ? STATE_FLAG : STATE_DISC;
            STATE_DISC: begin
                next_state = in ? STATE_1 : STATE_0;
                disc_next = 1;
            end
            STATE_FLAG: begin
                next_state = in ? STATE_ERR : STATE_FLAG_DONE;
                flag_next = 1;
            end
            STATE_FLAG_DONE: next_state = in ? STATE_1 : STATE_0;
            STATE_ERR: begin
                next_state = in ? STATE_ERR : STATE_0;
                err_next = 1;
            end
            default:    next_state = STATE_0;
        endcase
    end

    // State and output registers (sequential)
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            current_state <= next_state;
            disc <= disc_next;
            flag <= flag_next;
            err <= err_next;
        end
    end

endmodule