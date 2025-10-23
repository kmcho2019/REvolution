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

// Timing parameters (7 bits)
localparam [6:0]
    RED_TIME    = 7'd10,
    YELLOW_TIME = 7'd5,
    GREEN_TIME  = 7'd60,
    SHORT_GREEN = 7'd10;

reg [1:0] state, next_state;
reg [6:0] timer, next_timer;
reg ped_shortened, next_ped_shortened;

// Timer enable: decrement only when timer > 0 to save power
wire timer_en = (timer != 7'd0);

// Next-state logic
always @(*) begin
    next_state = state;
    if (timer == 7'd0) begin
        case (state)
            RED:    next_state = GREEN;
            GREEN:  next_state = YELLOW;
            YELLOW: next_state = RED;
            default: next_state = RED;
        endcase
    end
end

// Next-timer logic
always @(*) begin
    next_timer = timer;
    case (state)
        RED: begin
            if (timer == 7'd0)
                next_timer = GREEN_TIME;
            else if (timer_en)
                next_timer = timer - 1;
        end
        GREEN: begin
            if (timer == 7'd0)
                next_timer = YELLOW_TIME;
            else if (pass_request && !ped_shortened && (timer > SHORT_GREEN))
                next_timer = SHORT_GREEN;
            else if (timer_en)
                next_timer = timer - 1;
        end
        YELLOW: begin
            if (timer == 7'd0)
                next_timer = RED_TIME;
            else if (timer_en)
                next_timer = timer - 1;
        end
        default: next_timer = RED_TIME;
    endcase
end

// ped_shortened update logic
always @(*) begin
    next_ped_shortened = ped_shortened;
    if (state != GREEN)
        next_ped_shortened = 1'b0; // reset when leaving green
    else if (pass_request && !ped_shortened && (timer > SHORT_GREEN))
        next_ped_shortened = 1'b1; // set when shortening green time
end

// Sequential block for state, timer, ped_shortened with async reset
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

// Output assignments combinationally derived from state
assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);

// Output the current timer value
assign clock = timer;

endmodule