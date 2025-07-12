module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output wire [5:0] clock, // 6-bit timer sufficient for 60 max
    output wire       red,
    output wire       yellow,
    output wire       green
);

// State encoding
localparam [1:0]
    RED    = 2'd0,
    GREEN  = 2'd1,
    YELLOW = 2'd2;

// Timing parameters (6 bits)
localparam [5:0]
    RED_TIME    = 6'd10,
    YELLOW_TIME = 6'd5,
    GREEN_TIME  = 6'd60,
    SHORT_GREEN = 6'd10;

// Synchronize and register pass_request to reduce glitches
reg pass_req_sync_0, pass_req_sync_1;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pass_req_sync_0 <= 1'b0;
        pass_req_sync_1 <= 1'b0;
    end else begin
        pass_req_sync_0 <= pass_request;
        pass_req_sync_1 <= pass_req_sync_0;
    end
end
wire pass_req = pass_req_sync_1;

// FSM registers
reg [1:0] state, next_state;
reg [5:0] timer, next_timer;
reg ped_shortened, next_ped_shortened;

// Timer enable - only count down when timer > 0 to save power
wire timer_en = (timer != 6'd0);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state         <= RED;
        timer         <= RED_TIME;
        ped_shortened <= 1'b0;
    end else begin
        state         <= next_state;
        timer         <= next_timer;
        ped_shortened <= next_ped_shortened;
    end
end

always @(*) begin
    // Default assignments: remain in current state and timer count down if enabled
    next_state         = state;
    next_timer         = timer_en ? timer - 6'd1 : timer;
    next_ped_shortened = ped_shortened;

    case (state)
        RED: begin
            if (timer == 6'd0) begin
                next_state         = GREEN;
                next_timer         = GREEN_TIME;
                next_ped_shortened = 1'b0;
            end
        end

        GREEN: begin
            // On pedestrian request, if green time > SHORT_GREEN and not shortened yet, shorten timer immediately
            if (pass_req && (timer > SHORT_GREEN) && !ped_shortened) begin
                next_timer         = SHORT_GREEN;
                next_ped_shortened = 1'b1;
            end else if (timer == 6'd0) begin
                next_state         = YELLOW;
                next_timer         = YELLOW_TIME;
                next_ped_shortened = 1'b0;
            end
        end

        YELLOW: begin
            if (timer == 6'd0) begin
                next_state         = RED;
                next_timer         = RED_TIME;
                next_ped_shortened = 1'b0;
            end
        end

        default: begin
            next_state         = RED;
            next_timer         = RED_TIME;
            next_ped_shortened = 1'b0;
        end
    endcase
end

// Outputs purely combinationally derived from state for minimal registers and glitches
assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);
assign clock  = timer;

endmodule