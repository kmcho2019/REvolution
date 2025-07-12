module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output wire [5:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
);

// One-hot state encoding for better timing and simpler next-state logic
localparam [2:0]
    RED    = 3'b001,
    GREEN  = 3'b010,
    YELLOW = 3'b100;

// Timing parameters fitting 6 bits (max 60)
localparam [5:0]
    RED_TIME    = 6'd10,
    YELLOW_TIME = 6'd5,
    GREEN_TIME  = 6'd60,
    SHORT_GREEN = 6'd10;

reg [2:0] state, next_state;
reg [5:0] timer, next_timer;

// Timer enable signal to reduce toggling when timer=0
wire timer_en = (timer != 6'd0);

// Determine if green time should be shortened on ped request
wire green_short_req = (state == GREEN) && pass_request && (timer > SHORT_GREEN);

// Sequential: state and timer update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
    end else begin
        state <= next_state;
        timer <= next_timer;
    end
end

// Combinational next-state and timer logic
always @(*) begin
    next_state = state;
    next_timer = timer;

    case (state)
        RED: begin
            if (timer == 6'd0) begin
                next_state = GREEN;
                next_timer = GREEN_TIME;
            end else if (timer_en) begin
                next_timer = timer - 1;
            end
        end

        GREEN: begin
            if (green_short_req) begin
                next_timer = SHORT_GREEN; // shorten green if requested and timer > SHORT_GREEN
                next_state = GREEN;
            end else if (timer == 6'd0) begin
                next_state = YELLOW;
                next_timer = YELLOW_TIME;
            end else if (timer_en) begin
                next_timer = timer - 1;
            end
        end

        YELLOW: begin
            if (timer == 6'd0) begin
                next_state = RED;
                next_timer = RED_TIME;
            end else if (timer_en) begin
                next_timer = timer - 1;
            end
        end

        default: begin
            next_state = RED;
            next_timer = RED_TIME;
        end
    endcase
end

// Outputs combinationally driven by one-hot states
assign red    = state[0];
assign green  = state[1];
assign yellow = state[2];
assign clock  = timer;

endmodule