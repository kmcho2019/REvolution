module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State definition
typedef enum reg [1:0] {
    IDLE = 2'b00,
    RED = 2'b01,
    YELLOW = 2'b10,
    GREEN = 2'b11
} state_t;

state_t state, next_state;

// State durations
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam MIN_GREEN   = 8'd10;

reg [7:0] timer;
reg [7:0] green_elapsed;  // Counts how many green cycles have elapsed

// State and timer update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        timer <= 8'd0;
        green_elapsed <= 8'd0;
    end else begin
        state <= next_state;
        timer <= (next_state != state) ? 
                    (next_state == RED ? RED_TIME :
                     next_state == YELLOW ? YELLOW_TIME :
                     next_state == GREEN ? GREEN_TIME : 8'd0)
                 : (timer == 0 ? 8'd0 : timer - 1);

        if (next_state == GREEN) begin
            // Increment green_elapsed only if still in GREEN state and timer not reset
            green_elapsed <= (state == GREEN && timer != (next_state != state ? GREEN_TIME : timer)) ?
                             green_elapsed + 1 : (state != GREEN ? 8'd0 : green_elapsed);
        end else begin
            green_elapsed <= 8'd0;
        end
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    case(state)
        IDLE: next_state = RED;
        RED: if (timer == 0) next_state = GREEN;
        GREEN: begin
            // Calculate remaining green time
            // Remaining = timer
            if (timer == 0)
                next_state = YELLOW;
            else if (pass_request && (timer > MIN_GREEN)) 
                next_state = YELLOW; // Shorten green immediately if more than 10 cycles left
            else
                next_state = GREEN;
        end
        YELLOW: if (timer == 0) next_state = RED;
        default: next_state = RED;
    endcase
end

// Output logic driven from current state
always @(*) begin
    red    = (state == RED);
    yellow = (state == YELLOW);
    green  = (state == GREEN);
    clock  = timer;
end

endmodule