module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Binary encoded states
    localparam [3:0] STATE_0    = 4'b0000;  // Initial state (prev input 0)
    localparam [3:0] STATE_1    = 4'b0001;  // 1
    localparam [3:0] STATE_2    = 4'b0010;  // 11
    localparam [3:0] STATE_3    = 4'b0011;  // 111
    localparam [3:0] STATE_4    = 4'b0100;  // 1111
    localparam [3:0] STATE_5    = 4'b0101;  // 11111
    localparam [3:0] STATE_6    = 4'b0110;  // 111111
    localparam [3:0] STATE_DISC = 4'b0111;  // 111110 (discard next bit)
    localparam [3:0] STATE_ERR  = 4'b1000;  // 1111111... (error)

    reg [3:0] current_state, next_state;
    reg next_disc, next_flag, next_err;

    // State transition logic
    always @(*) begin
        case (current_state)
            STATE_0:    next_state = in ? STATE_1 : STATE_0;
            STATE_1:    next_state = in ? STATE_2 : STATE_0;
            STATE_2:    next_state = in ? STATE_3 : STATE_0;
            STATE_3:    next_state = in ? STATE_4 : STATE_0;
            STATE_4:    next_state = in ? STATE_5 : STATE_0;
            STATE_5:    next_state = in ? STATE_6 : STATE_DISC;
            STATE_6:    next_state = in ? STATE_ERR : STATE_0;
            STATE_DISC: next_state = in ? STATE_1 : STATE_0;
            STATE_ERR:  next_state = in ? STATE_ERR : STATE_0;
            default:    next_state = STATE_0;
        endcase
    end

    // Next output logic
    always @(*) begin
        next_disc = (current_state == STATE_5) && !in;
        next_flag = (current_state == STATE_6) && !in;
        next_err = (current_state == STATE_6 && in) || 
                  (current_state == STATE_ERR);
    end

    // Register outputs and state
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            current_state <= next_state;
            disc <= next_disc;
            flag <= next_flag;
            err <= next_err;
        end
    end

endmodule