module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output wire [6:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
);

// State encoding
localparam [1:0]
    RED    = 2'b00,
    GREEN  = 2'b01,
    YELLOW = 2'b10;

// Timing parameters (7 bits cover max 60)
localparam [6:0]
    RED_TIME    = 7'd10,
    YELLOW_TIME = 7'd5,
    GREEN_TIME  = 7'd60,
    SHORT_GREEN = 7'd10;

reg [1:0] state, next_state;
reg [6:0] timer, next_timer;
reg ped_shortened, next_ped_shortened;

// Timer enable to reduce toggling when zero
wire timer_en = (timer != 7'd0);

// Sequential logic: state, timer, ped_shortened update
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

// Combinational next-state and next-timer logic
always @(*) begin
    // Default assignments
    next_state         = state;
    next_timer         = timer;
    next_ped_shortened = ped_shortened;

    case (state)
        RED: begin
            if (timer == 7'd0) begin
                next_state         = GREEN;
                next_timer         = GREEN_TIME;
                next_ped_shortened = 1'b0;
            end else if (timer_en) begin
                next_timer = timer - 7'd1;
            end
        end

        GREEN: begin
            if (pass_request && (timer > SHORT_GREEN) && !ped_shortened) begin
                // Immediately shorten green timer on pedestrian request if not shortened before
                next_timer         = SHORT_GREEN;
                next_ped_shortened = 1'b1;
            end else if (timer == 7'd0) begin
                next_state         = YELLOW;
                next_timer         = YELLOW_TIME;
                next_ped_shortened = 1'b0;
            end else if (timer_en) begin
                next_timer = timer - 7'd1;
            end
        end

        YELLOW: begin
            if (timer == 7'd0) begin
                next_state         = RED;
                next_timer         = RED_TIME;
                next_ped_shortened = 1'b0;
            end else if (timer_en) begin
                next_timer = timer - 7'd1;
            end
        end

        default: begin
            next_state         = RED;
            next_timer         = RED_TIME;
            next_ped_shortened = 1'b0;
        end
    endcase
end

// Outputs combinational from state and timer
assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);
assign clock  = timer;

endmodule