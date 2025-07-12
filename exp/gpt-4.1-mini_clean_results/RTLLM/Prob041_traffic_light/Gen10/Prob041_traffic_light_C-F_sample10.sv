module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding (2-bit)
localparam RED    = 2'd0;
localparam GREEN  = 2'd1;
localparam YELLOW = 2'd2;

// Durations
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] timer, next_timer;
reg ped_shortened, next_ped_shortened;

// State transition logic
always @(*) begin
    case (state)
        RED:    next_state = (timer == 0) ? GREEN  : RED;
        GREEN:  next_state = (timer == 0) ? YELLOW : GREEN;
        YELLOW: next_state = (timer == 0) ? RED    : YELLOW;
        default: next_state = RED;
    endcase
end

// Timer and ped_shortened update logic
always @(*) begin
    // Default: keep current timer and ped_shortened
    next_timer = timer;
    next_ped_shortened = ped_shortened;

    if (state != next_state) begin
        // State change: reload timer for next_state and reset ped_shortened if leaving green
        case (next_state)
            RED:    next_timer = RED_TIME;
            GREEN:  next_timer = GREEN_TIME;
            YELLOW: next_timer = YELLOW_TIME;
            default: next_timer = RED_TIME;
        endcase

        if (next_state == GREEN)
            next_ped_shortened = 1'b0; // New green phase: reset flag
        else
            next_ped_shortened = 1'b0; // Not green: no shortening active
    end else begin
        // No state change
        if (state == GREEN) begin
            // If pass_request active and not shortened yet and timer > SHORT_GREEN,
            // clamp timer to SHORT_GREEN and set ped_shortened
            if (pass_request && !ped_shortened && (timer > SHORT_GREEN)) begin
                next_timer = SHORT_GREEN;
                next_ped_shortened = 1'b1;
            end else if (timer != 0) begin
                next_timer = timer - 1;
                next_ped_shortened = ped_shortened;
            end
            else begin
                next_timer = 0;
                next_ped_shortened = ped_shortened;
            end
        end else begin
            // In RED or YELLOW states, decrement timer if > 0
            if (timer != 0)
                next_timer = timer - 1;
            else
                next_timer = 0;
            next_ped_shortened = 1'b0; // Ensure flag off outside green
        end
    end
end

// Sequential updates on clock edge and async reset
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

// Output logic based on registered state
always @(*) begin
    red    = (state == RED);
    yellow = (state == YELLOW);
    green  = (state == GREEN);
    clock  = timer;
end

endmodule