module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output wire [7:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
);

// State encoding
localparam IDLE    = 2'd0; // not strictly needed but kept for completeness
localparam RED     = 2'd1;
localparam GREEN   = 2'd2;
localparam YELLOW  = 2'd3;

// Timing parameters
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] timer, next_timer;
reg ped_shortened, next_ped_shortened;

// Combinational next state and timer logic
always @(*) begin
    // Default assignments to hold current values and decrement timer if not zero
    next_state = state;
    if (timer != 0)
        next_timer = timer - 8'd1;
    else
        next_timer = 8'd0;

    // Default pedestrian shortened flag unchanged
    next_ped_shortened = ped_shortened;

    case (state)
        IDLE: begin
            next_state = RED;
            next_timer = RED_TIME;
            next_ped_shortened = 1'b0;
        end

        RED: begin
            if (timer == 8'd0) begin
                next_state = GREEN;
                next_timer = GREEN_TIME;
                next_ped_shortened = 1'b0; // Reset shortening flag on entering green
            end
        end

        GREEN: begin
            // Shorten green if pass_request asserted, not shortened yet, and timer > SHORT_GREEN
            if (pass_request && !ped_shortened && timer > SHORT_GREEN) begin
                next_timer = SHORT_GREEN;
                next_ped_shortened = 1'b1;
            end else if (timer == 8'd0) begin
                next_state = YELLOW;
                next_timer = YELLOW_TIME;
                next_ped_shortened = 1'b0;
            end
        end

        YELLOW: begin
            if (timer == 8'd0) begin
                next_state = RED;
                next_timer = RED_TIME;
                next_ped_shortened = 1'b0;
            end
        end

        default: begin
            next_state = RED;
            next_timer = RED_TIME;
            next_ped_shortened = 1'b0;
        end
    endcase
end

// Sequential logic: update state, timer, and ped_shortened on clock edge or reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
        ped_shortened <= 1'b0;
    end else begin
        state <= next_state;
        timer <= next_timer;
        ped_shortened <= next_ped_shortened;
    end
end

// Outputs combinationally driven from state
assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);
assign clock  = timer;

endmodule