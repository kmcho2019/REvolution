module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding
localparam IDLE      = 2'd0;
localparam RED       = 2'd1;
localparam YELLOW    = 2'd2;
localparam GREEN     = 2'd3;

// State durations in cycles
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] timer, next_timer;
reg ped_shortened;          // Flag to indicate if green shortening was applied this green phase

// State and timer register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
        ped_shortened <= 1'b0;
    end else begin
        state <= next_state;
        timer <= next_timer;
        if (state != GREEN)
            ped_shortened <= 1'b0;  // Reset shortening flag when leaving green
        else if (next_state == GREEN)
            ped_shortened <= ped_shortened; // Hold if still green
        else
            ped_shortened <= 1'b0;
    end
end

// Next state and timer combinational logic
always @(*) begin
    // Default assignments: hold state and decrement timer if not zero
    next_state = state;
    if (timer != 0)
        next_timer = timer - 1;
    else
        next_timer = 0;

    case(state)
        RED: begin
            if (timer == 0) begin
                next_state = GREEN;
                next_timer = GREEN_TIME;
            end
        end

        GREEN: begin
            // If pedestrian request is asserted, shortening not done yet,
            // and timer is greater than SHORT_GREEN, clamp timer to SHORT_GREEN
            if (pass_request && !ped_shortened && (timer > SHORT_GREEN)) begin
                next_timer = SHORT_GREEN;
                next_state = GREEN;
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

endmodule