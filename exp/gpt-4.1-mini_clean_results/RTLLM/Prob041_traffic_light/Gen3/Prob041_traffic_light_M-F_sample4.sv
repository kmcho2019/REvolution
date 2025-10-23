module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [7:0] clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

    // State encoding
    localparam [1:0]
        IDLE    = 2'd0,
        S1_RED  = 2'd1,
        S3_GREEN= 2'd2,
        S2_YELLOW=2'd3;

    // Timing parameters per problem statement
    localparam [7:0]
        RED_TIME    = 8'd10,
        YELLOW_TIME = 8'd5,
        GREEN_TIME  = 8'd60,
        MIN_GREEN_TIME = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] cnt, cnt_next;

    // Pedestrian request synchronized and latched to trigger shortening only once per green phase
    reg pass_req_sync0, pass_req_sync1;
    reg ped_shortened;  // flag indicating green time has been shortened for current green phase

    // Synchronize pass_request input to clk domain
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pass_req_sync0 <= 1'b0;
            pass_req_sync1 <= 1'b0;
        end else begin
            pass_req_sync0 <= pass_request;
            pass_req_sync1 <= pass_req_sync0;
        end
    end

    wire pass_req_sync = pass_req_sync1;

    // FSM: Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:      next_state = S1_RED; // immediate transition on reset deassertion
            S1_RED:    if (cnt == 0) next_state = S3_GREEN;
            S3_GREEN:  if (cnt == 0) next_state = S2_YELLOW;
            S2_YELLOW: if (cnt == 0) next_state = S1_RED;
            default:   next_state = IDLE;
        endcase
    end

    // Counter and state update sequential block
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 8'd10;        // initialize with red time on reset (per problem)
            ped_shortened <= 1'b0;
        end else begin
            // State update
            state <= next_state;

            if (state != next_state) begin
                // State entry: load counter accordingly and reset ped_shortened flag at green start
                case (next_state)
                    S1_RED:    cnt <= RED_TIME;
                    S2_YELLOW: cnt <= YELLOW_TIME;
                    S3_GREEN:  begin
                        cnt <= GREEN_TIME;
                        ped_shortened <= 1'b0; // clear flag on green start
                    end
                    default:   cnt <= 8'd0;
                endcase
            end else begin
                // Within a state, count down if counter > 0
                if (cnt > 0) begin
                    // During green, check pedestrian request shortening logic
                    if (state == S3_GREEN) begin
                        // If pedestrian request active, remaining time > 10, and not yet shortened
                        if (pass_req_sync && (cnt > MIN_GREEN_TIME) && !ped_shortened) begin
                            cnt <= MIN_GREEN_TIME; // shorten to 10 cycles remaining
                            ped_shortened <= 1'b1;
                        end else begin
                            cnt <= cnt - 1;
                        end
                    end else begin
                        // Other states: decrement normally
                        cnt <= cnt - 1;
                    end
                end
            end
        end
    end

    // Outputs: synchronous to clk, based on current state
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
            clock <= 8'd0;
        end else begin
            case (state)
                S1_RED: begin
                    red <= 1'b1;
                    yellow <= 1'b0;
                    green <= 1'b0;
                end
                S2_YELLOW: begin
                    red <= 1'b0;
                    yellow <= 1'b1;
                    green <= 1'b0;
                end
                S3_GREEN: begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b1;
                end
                default: begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b0;
                end
            endcase
            clock <= cnt;
        end
    end

endmodule