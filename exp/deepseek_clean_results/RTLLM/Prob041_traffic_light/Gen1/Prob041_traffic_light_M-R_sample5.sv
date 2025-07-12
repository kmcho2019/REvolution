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
parameter RED_TIME   = 8'd10;
parameter YELLOW_TIME = 8'd5;
parameter GREEN_TIME = 8'd60;
parameter MIN_GREEN  = 8'd10;

// State definitions
typedef enum logic [1:0] {
    IDLE,
    RED,
    YELLOW,
    GREEN
} state_t;

// Internal signals
reg [7:0] cnt;
state_t state;
wire red_active, yellow_active, green_active;

// State and counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt <= RED_TIME;
    end else begin
        case (state)
            IDLE: begin
                state <= RED;
                cnt <= RED_TIME;
            end
            
            RED: begin
                if (cnt == 1) begin
                    state <= GREEN;
                    cnt <= GREEN_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            YELLOW: begin
                if (cnt == 1) begin
                    state <= RED;
                    cnt <= RED_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            GREEN: begin
                // Handle pedestrian request
                if (pass_request && (cnt > MIN_GREEN)) begin
                    cnt <= MIN_GREEN;
                end
                // Normal countdown
                else if (cnt == 1) begin
                    state <= YELLOW;
                    cnt <= YELLOW_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            default: begin
                state <= IDLE;
                cnt <= RED_TIME;
            end
        endcase
    end
end

// Output assignments
assign red_active = (state == RED);
assign yellow_active = (state == YELLOW);
assign green_active = (state == GREEN);

assign red = red_active;
assign yellow = yellow_active;
assign green = green_active;
assign clock = cnt;

endmodule