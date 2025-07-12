module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output wire [5:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
);

// One-hot state encoding for speed
localparam [2:0]
    RED    = 3'b001,
    GREEN  = 3'b010,
    YELLOW = 3'b100;

// Timing constants (6 bits sufficient for max 60)
localparam [5:0]
    RED_TIME    = 6'd10,
    YELLOW_TIME = 6'd5,
    GREEN_TIME  = 6'd60,
    SHORT_GREEN = 6'd10;

reg [2:0] state, next_state;
reg [5:0] timer, next_timer;
reg       ped_shortened, next_ped_shortened;

// Timer enable: active only if timer non-zero
wire timer_en = (timer != 6'd0);

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

// Combinational next-state, timer, ped_shortened logic
always @(*) begin
    next_state         = state;
    next_timer         = timer;
    next_ped_shortened = ped_shortened;

    case (state)
        RED: begin
            if (timer == 6'd0) begin
                next_state         = GREEN;
                next_timer         = GREEN_TIME;
                next_ped_shortened = 1'b0;
            end else if (timer_en) begin
                next_timer = timer - 6'd1;
            end
        end

        GREEN: begin
            // If pedestrian requested and not shortened yet and remaining green > SHORT_GREEN
            if (pass_request && (timer > SHORT_GREEN) && !ped_shortened) begin
                next_timer         = SHORT_GREEN;
                next_ped_shortened = 1'b1;
                // remain in GREEN state
            end else if (timer == 6'd0) begin
                next_state         = YELLOW;
                next_timer         = YELLOW_TIME;
                next_ped_shortened = 1'b0;
            end else if (timer_en) begin
                next_timer = timer - 6'd1;
            end
        end

        YELLOW: begin
            if (timer == 6'd0) begin
                next_state         = RED;
                next_timer         = RED_TIME;
                next_ped_shortened = 1'b0;
            end else if (timer_en) begin
                next_timer = timer - 6'd1;
            end
        end

        default: begin
            next_state         = RED;
            next_timer         = RED_TIME;
            next_ped_shortened = 1'b0;
        end
    endcase
end

// Outputs combinationally driven from state
assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);
assign clock  = timer;

endmodule