module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,  // Reduced to 6 bits (max count 60)
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
reg [5:0] cnt;  // 6-bit counter (sufficient for max count 60)
reg r_red, r_yellow, r_green;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt <= RED_TIME;
    end else begin
        state <= next_state;
    end
end

// Next state and counter logic
always @(*) begin
    next_state = state;
    
    case (state)
        IDLE: next_state = RED;
        
        RED: begin
            if (cnt == 1) next_state = GREEN;
        end
        
        YELLOW: begin
            if (cnt == 1) next_state = RED;
        end
        
        GREEN: begin
            // Handle pedestrian request
            if (pass_request && cnt > MIN_GREEN) begin
                cnt = MIN_GREEN;
            end
            if (cnt == 1) next_state = YELLOW;
        end
        
        default: next_state = IDLE;
    endcase
end

// Counter management
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else begin
        case (state)
            RED: begin
                if (cnt == 1) cnt <= GREEN_TIME;
                else cnt <= cnt - 1;
            end
            
            YELLOW: begin
                if (cnt == 1) cnt <= RED_TIME;
                else cnt <= cnt - 1;
            end
            
            GREEN: begin
                if (pass_request && cnt > MIN_GREEN) begin
                    cnt <= MIN_GREEN;
                end
                else if (cnt == 1) begin
                    cnt <= YELLOW_TIME;
                end
                else begin
                    cnt <= cnt - 1;
                end
            end
            
            default: cnt <= RED_TIME;
        endcase
    end
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r_red <= 1'b0;
        r_yellow <= 1'b0;
        r_green <= 1'b0;
    end else begin
        r_red <= (state == RED);
        r_yellow <= (state == YELLOW);
        r_green <= (state == GREEN);
    end
end

// Output assignments
assign clock = cnt;
assign red = r_red;
assign yellow = r_yellow;
assign green = r_green;

endmodule