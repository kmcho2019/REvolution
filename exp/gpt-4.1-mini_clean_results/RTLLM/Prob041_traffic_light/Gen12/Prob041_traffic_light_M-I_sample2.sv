module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg [7:0]  clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

// State encoding
localparam [1:0]
    S_RED    = 2'd0,
    S_GREEN  = 2'd1,
    S_YELLOW = 2'd2;

// Timing constants
localparam [7:0]
    TIME_RED    = 8'd10,
    TIME_YELLOW = 8'd5,
    TIME_GREEN  = 8'd60,
    TIME_SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] timer, next_timer;

wire green_active = (state == S_GREEN);
wire yellow_active = (state == S_YELLOW);
wire red_active = (state == S_RED);

// Determine if pedestrian shortening should apply
wire shorten_green = green_active && pass_request && (timer > TIME_SHORT_GREEN);

// Combinational next state and timer logic
always @(*) begin
    next_state = state;
    next_timer = timer;

    if (timer == 0) begin
        case (state)
            S_RED:    next_state = S_GREEN;
            S_GREEN:  next_state = S_YELLOW;
            S_YELLOW: next_state = S_RED;
            default:  next_state = S_RED;
        endcase

        case (state)
            S_RED:    next_timer = TIME_GREEN;
            S_GREEN:  next_timer = TIME_YELLOW;
            S_YELLOW: next_timer = TIME_RED;
            default:  next_timer = TIME_RED;
        endcase
    end else begin
        if (shorten_green) begin
            // Clamp timer to short green if requested
            if (timer > TIME_SHORT_GREEN)
                next_timer = TIME_SHORT_GREEN;
            else
                next_timer = timer - 1;
        end else begin
            // Normal countdown
            next_timer = timer - 1;
        end
    end
end

// Sequential logic for state and timer
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S_RED;
        timer <= TIME_RED;
    end else begin
        state <= next_state;
        timer <= next_timer;
    end
end

// Synchronously register outputs to prevent glitches
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red    <= 1'b0;
        yellow <= 1'b0;
        green  <= 1'b0;
        clock  <= 8'd0;
    end else begin
        red    <= (state == S_RED);
        yellow <= (state == S_YELLOW);
        green  <= (state == S_GREEN);
        clock  <= timer;
    end
end

endmodule