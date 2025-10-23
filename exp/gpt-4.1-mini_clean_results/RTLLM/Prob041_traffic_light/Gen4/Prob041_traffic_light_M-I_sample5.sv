module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding
localparam IDLE      = 2'd0;
localparam RED       = 2'd1;
localparam YELLOW    = 2'd2;
localparam GREEN     = 2'd3;

// State durations in cycles (6-bit width)
localparam RED_TIME    = 6'd10;
localparam YELLOW_TIME = 6'd5;
localparam GREEN_TIME  = 6'd60;
localparam SHORT_GREEN = 6'd10;

reg [1:0] state, next_state;
reg [5:0] timer, next_timer;
reg ped_shortened; // Flag to indicate if green shortening was applied this green phase

wire timer_enable = (timer != 0);

// State and timer update block
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
        ped_shortened <= 1'b0;
    end else begin
        state <= next_state;
        timer <= next_timer;

        // Reset ped_shortened flag on GREEN entry
        if (state != GREEN && next_state == GREEN)
            ped_shortened <= 1'b0;
        else if (state == GREEN)
            ped_shortened <= ped_shortened; // hold current value
        else
            ped_shortened <= 1'b0; // clear in other states
    end
end

// Next state and timer combinational logic
always @(*) begin
    next_state = state;
    next_timer = timer;

    // Timer decrement only if timer > 0
    if (timer_enable)
        next_timer = timer - 1;

    case(state)
        RED: begin
            if (timer == 0) begin
                next_state = GREEN;
                next_timer = GREEN_TIME;
            end
        end

        GREEN: begin
            // Shorten green if pass_request asserted, not already shortened, and timer > SHORT_GREEN
            if (pass_request && !ped_shortened && (timer > SHORT_GREEN)) begin
                next_timer = SHORT_GREEN;
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

// Output logic combinationally based on state
always @(*) begin
    red    = (state == RED);
    yellow = (state == YELLOW);
    green  = (state == GREEN);
    clock  = timer;
end

// ped_shortened update control: only update to 1 when shortening happens
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // handled above
    end else begin
        if (state == GREEN && pass_request && !ped_shortened && (timer > SHORT_GREEN))
            ped_shortened <= 1'b1;
    end
end

endmodule