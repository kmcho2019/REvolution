module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [7:0] clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

    // State encoding as parameters for clarity
    localparam [1:0]
        IDLE     = 2'd0,
        RED      = 2'd1,
        YELLOW   = 2'd2,
        GREEN    = 2'd3;

    // Timing parameters
    localparam [7:0]
        RED_TIME       = 8'd10,
        YELLOW_TIME    = 8'd5,
        GREEN_TIME     = 8'd60,
        MIN_GREEN_TIME = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] cnt, cnt_next;

    // Pedestrian request latch for one-shot shortening
    reg ped_req_latched;

    // Synchronize pedestrian request (optional, depends on input timing)
    reg pass_request_sync1, pass_request_sync2;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            pass_request_sync1 <= 1'b0;
            pass_request_sync2 <= 1'b0;
        end else begin
            pass_request_sync1 <= pass_request;
            pass_request_sync2 <= pass_request_sync1;
        end
    end
    wire pass_req_sync = pass_request_sync2;

    // FSM next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE:    next_state = RED;
            RED:     if(cnt == 0) next_state = GREEN;
            YELLOW:  if(cnt == 0) next_state = RED;
            GREEN:   if(cnt == 0) next_state = YELLOW;
            default: next_state = IDLE;
        endcase
    end

    // Counter and state update sequential block
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= IDLE;
            cnt <= RED_TIME;
            ped_req_latched <= 1'b0;
        end else begin
            state <= next_state;

            // Load counter at state entry
            if(state != next_state) begin
                case(next_state)
                    RED:    cnt <= RED_TIME;
                    YELLOW: cnt <= YELLOW_TIME;
                    GREEN:  cnt <= GREEN_TIME;
                    default: cnt <= 8'd0;
                endcase
                ped_req_latched <= 1'b0;  // Reset pedestrian request latch on new state
            end else begin
                // In GREEN state, handle pedestrian request shortening once
                if(state == GREEN) begin
                    if(pass_req_sync && (cnt > MIN_GREEN_TIME) && !ped_req_latched) begin
                        cnt <= MIN_GREEN_TIME;
                        ped_req_latched <= 1'b1; // latch to avoid multiple shortenings
                    end else if(cnt > 0) begin
                        cnt <= cnt - 1;
                    end
                end else begin
                    // Normal count down for other states if cnt > 0
                    if(cnt > 0)
                        cnt <= cnt - 1;
                end
            end
        end
    end

    // Outputs combinational from current state
    always @(*) begin
        red = 1'b0;
        yellow = 1'b0;
        green = 1'b0;
        case(state)
            RED:    red = 1'b1;
            YELLOW: yellow = 1'b1;
            GREEN:  green = 1'b1;
            default: begin end
        endcase
    end

    // Output the current counter
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            clock <= 8'd0;
        else
            clock <= cnt;
    end

endmodule