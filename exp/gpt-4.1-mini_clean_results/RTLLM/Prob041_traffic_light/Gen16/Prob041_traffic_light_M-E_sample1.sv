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
localparam IDLE   = 2'b00;
localparam RED    = 2'b01;
localparam GREEN  = 2'b10;
localparam YELLOW = 2'b11;

// Timing parameters
localparam RED_TIME    = 8'd10;
localparam GREEN_TIME  = 8'd60;
localparam YELLOW_TIME = 8'd5;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] timer, next_timer;
reg       green_shortened, next_green_shortened;

// State and timer update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state            <= IDLE;
        timer            <= 8'd0;
        green_shortened  <= 1'b0;
    end else begin
        state            <= next_state;
        timer            <= next_timer;
        green_shortened  <= next_green_shortened;
    end
end

// Next state logic and timer control
always @(*) begin
    next_state = state;
    next_timer = timer;
    next_green_shortened = green_shortened;

    case(state)
        IDLE: begin
            // Initialize with RED state and timer
            next_state = RED;
            next_timer = RED_TIME;
            next_green_shortened = 1'b0;
        end
        RED: begin
            if (timer == 0) begin
                next_state = GREEN;
                next_timer = GREEN_TIME;
                next_green_shortened = 1'b0;
            end else begin
                next_timer = timer - 1;
            end
        end
        GREEN: begin
            // Handle pedestrian button: if more than SHORT_GREEN time left, shorten once
            if ((pass_request) && (timer > SHORT_GREEN) && (!green_shortened)) begin
                next_timer = SHORT_GREEN;
                next_green_shortened = 1'b1;
            end else if (timer == 0) begin
                next_state = YELLOW;
                next_timer = YELLOW_TIME;
                next_green_shortened = 1'b0;
            end else begin
                next_timer = timer - 1;
            end
        end
        YELLOW: begin
            if (timer == 0) begin
                next_state = RED;
                next_timer = RED_TIME;
                next_green_shortened = 1'b0;
            end else begin
                next_timer = timer - 1;
            end
        end
        default: begin
            next_state = IDLE;
            next_timer = 0;
            next_green_shortened = 1'b0;
        end
    endcase
end

// Outputs based on current state
always @(*) begin
    red    = (state == RED);
    yellow = (state == YELLOW);
    green  = (state == GREEN);
    clock  = timer;
end

endmodule