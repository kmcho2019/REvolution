module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Define states with optimized encoding
    localparam STATE_0    = 3'd0;
    localparam STATE_1    = 3'd1;
    localparam STATE_2    = 3'd2;
    localparam STATE_3    = 3'd3;
    localparam STATE_4    = 3'd4;
    localparam STATE_5    = 3'd5;
    localparam STATE_DISC = 3'd6;
    localparam STATE_FLAG = 3'd7;
    localparam STATE_ERR  = 3'd8;  // Added missing state definition

    reg [3:0] current_state, next_state;  // Expanded to accommodate STATE_ERR

    // State transition logic (combinational)
    always @(*) begin
        next_state = current_state;
        
        case (current_state)
            STATE_0:    next_state = in ? STATE_1 : STATE_0;
            STATE_1:    next_state = in ? STATE_2 : STATE_0;
            STATE_2:    next_state = in ? STATE_3 : STATE_0;
            STATE_3:    next_state = in ? STATE_4 : STATE_0;
            STATE_4:    next_state = in ? STATE_5 : STATE_0;
            STATE_5:    next_state = in ? STATE_FLAG : STATE_DISC;
            STATE_FLAG: next_state = in ? STATE_ERR : STATE_0;
            STATE_DISC: next_state = STATE_0;
            STATE_ERR:  next_state = in ? STATE_ERR : STATE_0;
            default:    next_state = STATE_0;
        endcase
    end

    // Output generation (sequential)
    always @(posedge clk) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err <= 0;
            current_state <= STATE_0;
        end else begin
            current_state <= next_state;
            
            // Clear outputs by default
            disc <= 0;
            flag <= 0;
            err <= 0;
            
            // Set outputs based on state transitions
            case (next_state)
                STATE_DISC: disc <= 1;
                STATE_FLAG: flag <= (current_state == STATE_5) && in;
                STATE_ERR:  err <= (current_state == STATE_FLAG) && in;
            endcase
        end
    end

endmodule