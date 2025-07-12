module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// State definitions
typedef enum logic [1:0] {
    IDLE,
    RED,
    YELLOW,
    GREEN
} state_t;

// Duration parameters
parameter RED_DURATION = 10;
parameter YELLOW_DURATION = 5;
parameter GREEN_DURATION = 60;
parameter MIN_GREEN = 10;

// Internal signals
state_t current_state, next_state;
reg [7:0] counter;
wire counter_expired = (counter == 0);
wire green_override = (pass_request && (current_state == GREEN) && (counter > MIN_GREEN));

// Next state logic (combinational)
always_comb begin
    case (current_state)
        IDLE: next_state = RED;
        RED: next_state = counter_expired ? GREEN : RED;
        YELLOW: next_state = counter_expired ? RED : YELLOW;
        GREEN: next_state = (counter_expired || green_override && (counter == MIN_GREEN)) ? YELLOW : GREEN;
        default: next_state = IDLE;
    endcase
end

// Counter control (sequential)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        counter <= RED_DURATION;
    end
    else begin
        current_state <= next_state;
        
        // Counter update logic
        case (next_state)
            IDLE: counter <= RED_DURATION;
            RED: counter <= (current_state != RED) ? RED_DURATION : (counter - 1);
            YELLOW: counter <= (current_state != YELLOW) ? YELLOW_DURATION : (counter - 1);
            GREEN: begin
                if (current_state != GREEN) begin
                    counter <= GREEN_DURATION;
                end
                else if (green_override) begin
                    counter <= MIN_GREEN;
                end
                else begin
                    counter <= counter - 1;
                end
            end
        endcase
    end
end

// Output generation (combinational)
assign red = (current_state == RED);
assign yellow = (current_state == YELLOW);
assign green = (current_state == GREEN);
assign clock = counter;

endmodule