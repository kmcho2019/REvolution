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
localparam RED    = 2'd0;
localparam GREEN  = 2'd1;
localparam YELLOW = 2'd2;

// Durations
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

// Registers
reg [1:0] state, next_state;
reg [7:0] timer, next_timer;
reg shortened_flag, shortened_flag_next;

// Clock enable for state and timer update
wire cnt_enable = (timer != 0) || (state != next_state);

// State and timer update with clock enable gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
        shortened_flag <= 1'b0;
    end else if (cnt_enable) begin
        state <= next_state;
        timer <= next_timer;
        shortened_flag <= shortened_flag_next;
    end
end

// Next state logic
always @(*) begin
    // Default assignments
    next_state = state;

    if (timer == 0) begin
        case (state)
            RED:    next_state = GREEN;
            GREEN:  next_state = YELLOW;
            YELLOW: next_state = RED;
            default: next_state = RED;
        endcase
    end
end

// Next timer logic
always @(*) begin
    case (state)
        RED: begin
            if (timer == 0)
                next_timer = GREEN_TIME;
            else
                next_timer = timer - 1;
        end
        YELLOW: begin
            if (timer == 0)
                next_timer = RED_TIME;
            else
                next_timer = timer - 1;
        end
        GREEN: begin
            // If pass_request and not shortened and remaining time > SHORT_GREEN, clamp timer to SHORT_GREEN
            if (pass_request && !shortened_flag && timer > SHORT_GREEN)
                next_timer = SHORT_GREEN;
            else if (timer == 0)
                next_timer = YELLOW_TIME;
            else
                next_timer = timer - 1;
        end
        default: next_timer = RED_TIME;
    endcase
end

// Shortened flag logic
always @(*) begin
    if (state != GREEN)
        shortened_flag_next = 1'b0;
    else if (pass_request && !shortened_flag && timer > SHORT_GREEN)
        shortened_flag_next = 1'b1;
    else
        shortened_flag_next = shortened_flag;
end

// Registered outputs for glitch-free stable signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
        clock <= 8'd0;
    end else begin
        red <= (state == RED);
        yellow <= (state == YELLOW);
        green <= (state == GREEN);
        clock <= timer;
    end
end

endmodule