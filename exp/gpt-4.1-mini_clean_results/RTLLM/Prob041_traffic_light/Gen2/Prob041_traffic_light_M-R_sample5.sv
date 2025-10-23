module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output wire [7:0] clock,
    output wire red,
    output wire yellow,
    output wire green
);

// State encoding
typedef enum logic [1:0] {
    IDLE = 2'd0,
    RED = 2'd1,
    GREEN = 2'd2,
    YELLOW = 2'd3
} state_t;

state_t state, next_state;

reg [7:0] timer, next_timer;
// Flag to indicate if green time has been shortened in current green cycle
reg green_shortened, next_green_shortened;

// To detect rising edge of pass_request
reg pass_request_d, next_pass_request_d;

wire pass_request_rise = pass_request & ~pass_request_d;

// State and timer sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        timer <= 8'd0;
        green_shortened <= 1'b0;
        pass_request_d <= 1'b0;
    end else begin
        state <= next_state;
        timer <= next_timer;
        green_shortened <= next_green_shortened;
        pass_request_d <= pass_request;
    end
end

// Next state, timer, and green_shortened logic
always @(*) begin
    next_state = state;
    next_timer = timer;
    next_green_shortened = green_shortened;
    // pass_request_d updated only in sequential always

    case (state)
        IDLE: begin
            // Move immediately to RED with timer 10
            next_state = RED;
            next_timer = 8'd10;
            next_green_shortened = 1'b0;
        end

        RED: begin
            if (timer == 0) begin
                next_state = GREEN;
                next_timer = 8'd60;
                next_green_shortened = 1'b0; // Reset shortening flag at green start
            end else begin
                next_timer = timer - 1;
            end
        end

        GREEN: begin
            // Apply shortening only once per green phase on rising edge of pass_request
            if (pass_request_rise && !green_shortened && timer > 8'd10) begin
                next_timer = 8'd10;
                next_green_shortened = 1'b1;
            end else if (timer == 0) begin
                next_state = YELLOW;
                next_timer = 8'd5;
                next_green_shortened = 1'b0; // Reset flag for next green cycle
            end else begin
                next_timer = timer - 1;
            end
        end

        YELLOW: begin
            if (timer == 0) begin
                next_state = RED;
                next_timer = 8'd10;
                next_green_shortened = 1'b0;
            end else begin
                next_timer = timer - 1;
            end
        end

        default: begin
            next_state = IDLE;
            next_timer = 8'd0;
            next_green_shortened = 1'b0;
        end
    endcase
end

// Output logic combinationally based on current state
assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);
assign clock  = timer;

endmodule