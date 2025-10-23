module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [6:0] clock,   // Reduced width to 7 bits
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding (2 bits)
localparam IDLE      = 2'd0;
localparam RED       = 2'd1;
localparam YELLOW    = 2'd2;
localparam GREEN     = 2'd3;

// State durations in cycles (7 bits to cover max 60)
localparam RED_TIME    = 7'd10;
localparam YELLOW_TIME = 7'd5;
localparam GREEN_TIME  = 7'd60;
localparam SHORT_GREEN = 7'd10;

reg [1:0] state;
reg [6:0] timer;
reg ped_shortened;

// Combinational signals for next state and timer
reg [1:0] next_state;
reg [6:0] next_timer;
reg next_ped_shortened;

// Timer enable to reduce unnecessary toggling
wire timer_en = (state != IDLE) && (timer != 0);

// State and timer register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
        ped_shortened <= 1'b0;
    end else begin
        state <= next_state;
        // Update timer only if enabled, else hold current value
        if (timer_en)
            timer <= next_timer;
        else
            timer <= timer;
        ped_shortened <= next_ped_shortened;
    end
end

// Next state and timer combinational logic
always @(*) begin
    next_state = state;
    next_timer = timer;
    next_ped_shortened = ped_shortened;

    case(state)
        RED: begin
            if (timer == 0) begin
                next_state = GREEN;
                next_timer = GREEN_TIME;
                next_ped_shortened = 1'b0; // Reset shortening flag entering green
            end else if (timer_en) begin
                next_timer = timer - 1;
            end
        end

        GREEN: begin
            // Shorten green time only once if pass_request active and time > SHORT_GREEN
            if (pass_request && !ped_shortened && (timer > SHORT_GREEN)) begin
                next_timer = SHORT_GREEN;
                next_ped_shortened = 1'b1;
            end else if (timer == 0) begin
                next_state = YELLOW;
                next_timer = YELLOW_TIME;
                next_ped_shortened = 1'b0; // Clear shortening flag leaving green
            end else if (timer_en) begin
                next_timer = timer - 1;
            end
        end

        YELLOW: begin
            if (timer == 0) begin
                next_state = RED;
                next_timer = RED_TIME;
                next_ped_shortened = 1'b0;
            end else if (timer_en) begin
                next_timer = timer - 1;
            end
        end

        default: begin
            next_state = RED;
            next_timer = RED_TIME;
            next_ped_shortened = 1'b0;
        end
    endcase
end

// Output logic combinationally based on state and timer
always @(*) begin
    red    = (state == RED);
    yellow = (state == YELLOW);
    green  = (state == GREEN);
    clock  = timer;
end

endmodule