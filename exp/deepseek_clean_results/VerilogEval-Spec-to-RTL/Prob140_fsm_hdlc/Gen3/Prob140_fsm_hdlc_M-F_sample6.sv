module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Binary encoded states
    localparam [2:0] STATE_0    = 3'b000;  // Initial state (prev input 0)
    localparam [2:0] STATE_1    = 3'b001;  // 1
    localparam [2:0] STATE_2    = 3'b010;  // 11
    localparam [2:0] STATE_3    = 3'b011;  // 111
    localparam [2:0] STATE_4    = 3'b100;  // 1111
    localparam [2:0] STATE_5    = 3'b101;  // 11111
    localparam [2:0] STATE_DISC = 3'b110;  // 111110 (discard next bit)
    localparam [2:0] STATE_ERR  = 3'b111;  // 1111111... (error)

    reg [2:0] current_state, next_state;
    reg delayed_flag;

    // State transition logic
    always @(*) begin
        case (current_state)
            STATE_0:    next_state = in ? STATE_1 : STATE_0;
            STATE_1:    next_state = in ? STATE_2 : STATE_0;
            STATE_2:    next_state = in ? STATE_3 : STATE_0;
            STATE_3:    next_state = in ? STATE_4 : STATE_0;
            STATE_4:    next_state = in ? STATE_5 : STATE_0;
            STATE_5:    next_state = in ? STATE_ERR : STATE_DISC;
            STATE_DISC: next_state = in ? STATE_1 : STATE_0;
            STATE_ERR:  next_state = in ? STATE_ERR : STATE_0;
            default:    next_state = STATE_0;
        endcase
    end

    // Output generation (pure Moore machine)
    always @(*) begin
        disc = (current_state == STATE_DISC);
        flag = delayed_flag;
        err = (current_state == STATE_ERR);
    end

    // Flag detection (needs to be delayed by 1 cycle)
    always @(posedge clk) begin
        if (reset) begin
            delayed_flag <= 0;
        end else begin
            delayed_flag <= (current_state == STATE_5) && !in;
        end
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_0;
        end else begin
            current_state <= next_state;
        end
    end

endmodule