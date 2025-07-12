module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [6:0] clock,   // reduced from 8 bits to 7 bits (max count 60 fits in 7 bits)
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding
localparam IDLE      = 2'd0;
localparam RED       = 2'd1;
localparam YELLOW    = 2'd2;
localparam GREEN     = 2'd3;

// State durations in cycles (7 bits)
localparam RED_TIME    = 7'd10;
localparam YELLOW_TIME = 7'd5;
localparam GREEN_TIME  = 7'd60;
localparam SHORT_GREEN = 7'd10;

reg [1:0] state, next_state;
reg [6:0] timer, next_timer;
reg ped_shortened;          // Flag to indicate if green shortening applied in current green phase

// Timer enable: decrement only if timer > 0
wire timer_en = (timer != 0);

// State and timer registers update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
        ped_shortened <= 1'b0;
    end else begin
        state <= next_state;
        timer <= next_timer;
        // Reset ped_shortened when leaving green state
        if (state != GREEN)
            ped_shortened <= 1'b0;
        else if (state == GREEN && next_state == GREEN)
            ped_shortened <= ped_shortened;
        else
            ped_shortened <= 1'b0;
    end
end

// Next state and timer logic
always @(*) begin
    next_state = state;
    // Default: decrement timer if enabled
    if (timer_en)
        next_timer = timer - 1;
    else
        next_timer = timer;

    case(state)
        RED: begin
            if (timer == 0) begin
                next_state = GREEN;
                next_timer = GREEN_TIME;
            end
        end

        GREEN: begin
            // Pedestrian request shortening logic enabled only if not already shortened
            if (pass_request && !ped_shortened && (timer > SHORT_GREEN)) begin
                next_timer = SHORT_GREEN;
                next_state = GREEN; // hold state to continue counting
            end else if (timer == 0) begin
                next_state = YELLOW;
                next_timer = YELLOW_TIME;
            end
        end

        YELLOW: begin
            if (timer == 0) begin
                next_state = RED;
                next_timer = RED_TIME;
            end
        end

        default: begin
            next_state = RED;
            next_timer = RED_TIME;
        end
    endcase
end

// Output logic
always @(*) begin
    red    = (state == RED);
    yellow = (state == YELLOW);
    green  = (state == GREEN);
    clock  = timer;
end

endmodule