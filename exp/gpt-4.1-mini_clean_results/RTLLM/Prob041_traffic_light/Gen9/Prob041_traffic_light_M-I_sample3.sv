module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [6:0] clock, // Reduced width from 8 to 7 bits
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding (2 bits)
localparam IDLE      = 2'd0;
localparam RED       = 2'd1;
localparam YELLOW    = 2'd2;
localparam GREEN     = 2'd3;

// State durations fitting in 7 bits
localparam RED_TIME    = 7'd10;
localparam YELLOW_TIME = 7'd5;
localparam GREEN_TIME  = 7'd60;
localparam SHORT_GREEN = 7'd10;

reg [1:0] state, next_state;
reg [6:0] timer, next_timer;
reg ped_shortened, next_ped_shortened;

// Sequential block: state, timer, and ped_shortened updates
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

// Combinational logic for next state, timer, and ped_shortened
always @(*) begin
    // Default assignments
    next_state = state;
    next_timer = timer;
    next_ped_shortened = ped_shortened;

    // Timer decrements only when nonzero to reduce switching
    if (timer != 0) begin
        next_timer = timer - 1;
    end

    case(state)
        RED: begin
            if (timer == 0) begin
                next_state = GREEN;
                next_timer = GREEN_TIME;
                next_ped_shortened = 1'b0; // Reset shortening flag at green start
            end
        end

        GREEN: begin
            // Pedestrian request shortening applied once per green phase,
            // only if timer > SHORT_GREEN
            if (pass_request && !ped_shortened && (timer > SHORT_GREEN)) begin
                next_timer = SHORT_GREEN;
                next_ped_shortened = 1'b1;
            end else if (timer == 0) begin
                next_state = YELLOW;
                next_timer = YELLOW_TIME;
                next_ped_shortened = 1'b0; // Clear flag on leaving green
            end
        end

        YELLOW: begin
            if (timer == 0) begin
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

// Outputs combinationally based on current state
always @(*) begin
    red    = (state == RED);
    yellow = (state == YELLOW);
    green  = (state == GREEN);
    clock  = timer;
end

endmodule