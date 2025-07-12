module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output wire [7:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
);

// State encoding using 2 bits
localparam [1:0]
    IDLE   = 2'd0,
    RED    = 2'd1,
    YELLOW = 2'd2,
    GREEN  = 2'd3;

// Timing constants
localparam [6:0]
    RED_TIME    = 7'd10,
    YELLOW_TIME = 7'd5,
    GREEN_TIME  = 7'd60,
    SHORT_GREEN = 7'd10;

// Registers for state, timer, and pedestrian shortening flag
reg [1:0] state, next_state;
reg [6:0] timer, next_timer;
reg ped_shortened, next_ped_shortened;

// Timer enable signal to reduce toggling when timer is zero
wire timer_en = (timer != 7'd0);

// Sequential logic: state, timer, ped_shortened update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state         <= IDLE;
        timer         <= 7'd0;
        ped_shortened <= 1'b0;
    end else begin
        state         <= next_state;
        timer         <= next_timer;
        ped_shortened <= next_ped_shortened;
    end
end

// Combinational logic for next state, timer, and ped_shortened
always @(*) begin
    // Defaults
    next_state         = state;
    next_timer         = timer;
    next_ped_shortened = ped_shortened;

    case (state)
        IDLE: begin
            // Immediately transition to RED with timer set
            next_state = RED;
            next_timer = RED_TIME;
            next_ped_shortened = 1'b0;
        end

        RED: begin
            if (timer == 7'd0) begin
                next_state         = GREEN;
                next_timer         = GREEN_TIME;
                next_ped_shortened = 1'b0;
            end else if (timer_en) begin
                next_timer = timer - 7'd1;
            end
        end

        GREEN: begin
            if (pass_request && (timer > SHORT_GREEN) && !ped_shortened) begin
                // Shorten green timer immediately on pedestrian request
                next_timer         = SHORT_GREEN;
                next_ped_shortened = 1'b1;
            end else if (timer == 7'd0) begin
                next_state         = YELLOW;
                next_timer         = YELLOW_TIME;
                next_ped_shortened = 1'b0;
            end else if (timer_en) begin
                next_timer = timer - 7'd1;
            end
        end

        YELLOW: begin
            if (timer == 7'd0) begin
                next_state         = RED;
                next_timer         = RED_TIME;
                next_ped_shortened = 1'b0;
            end else if (timer_en) begin
                next_timer = timer - 7'd1;
            end
        end

        default: begin
            // Safety fallback to IDLE
            next_state         = IDLE;
            next_timer         = 7'd0;
            next_ped_shortened = 1'b0;
        end
    endcase
end

// Outputs derived combinationally from state and timer
assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);
// Extend timer to 8 bits by zero-padding MSB for output compliance
assign clock  = {1'b0, timer};

endmodule