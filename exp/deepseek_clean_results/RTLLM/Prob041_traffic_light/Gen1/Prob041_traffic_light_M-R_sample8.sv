module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Timing parameters
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// State encoding
typedef enum {IDLE, RED, YELLOW, GREEN} state_t;
state_t state, next_state;

// Counter and outputs
reg [7:0] cnt;
reg r_red, r_yellow, r_green;

// State transition and output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        r_red <= 1'b0;
        r_yellow <= 1'b0;
        r_green <= 1'b0;
    end else begin
        state <= next_state;
        
        // Default outputs
        r_red <= 1'b0;
        r_yellow <= 1'b0;
        r_green <= 1'b0;
        
        case (state)
            RED:    r_red <= 1'b1;
            YELLOW: r_yellow <= 1'b1;
            GREEN:  r_green <= 1'b1;
            default: ; // IDLE state
        endcase
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    case (state)
        IDLE:   next_state = RED;
        RED:    if (cnt == 1) next_state = GREEN;
        YELLOW: if (cnt == 1) next_state = RED;
        GREEN:  if (cnt == 1) next_state = YELLOW;
    endcase
end

// Counter management
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else begin
        // Handle pedestrian request
        if (pass_request && (state == GREEN) && (cnt > MIN_GREEN)) begin
            cnt <= MIN_GREEN;
        end
        // State transition counter updates
        else if (cnt == 1) begin
            case (state)
                RED:    cnt <= GREEN_TIME;
                YELLOW: cnt <= RED_TIME;
                GREEN:  cnt <= YELLOW_TIME;
                default: cnt <= RED_TIME;
            endcase
        end else begin
            cnt <= cnt - 1;
        end
    end
end

// Output assignments
assign clock = cnt;
assign red = r_red;
assign yellow = r_yellow;
assign green = r_green;

endmodule