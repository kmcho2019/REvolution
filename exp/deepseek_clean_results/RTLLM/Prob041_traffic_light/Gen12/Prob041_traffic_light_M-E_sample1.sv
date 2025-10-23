module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Major states
typedef enum logic [1:0] {
    MAJOR_RED,
    MAJOR_YELLOW,
    MAJOR_GREEN
} major_state_t;

// Sub-states for green phase
typedef enum logic {
    GREEN_NORMAL,
    GREEN_SHORTENED
} green_substate_t;

// State registers
major_state_t major_state;
green_substate_t green_substate;
reg [5:0] cnt;  // 6-bit counter (max 60)
reg pass_request_sync;

// Synchronize pedestrian request
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pass_request_sync <= 0;
    end else begin
        pass_request_sync <= pass_request;
    end
end

// Main state machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        major_state <= MAJOR_RED;
        green_substate <= GREEN_NORMAL;
        cnt <= 10;
    end else begin
        case (major_state)
            MAJOR_RED: begin
                if (cnt == 0) begin
                    major_state <= MAJOR_GREEN;
                    cnt <= 60;
                    green_substate <= GREEN_NORMAL;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            MAJOR_YELLOW: begin
                if (cnt == 0) begin
                    major_state <= MAJOR_RED;
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            MAJOR_GREEN: begin
                // Handle pedestrian request
                if (pass_request_sync && green_substate == GREEN_NORMAL) begin
                    if (cnt > 10) begin
                        cnt <= 10;
                        green_substate <= GREEN_SHORTENED;
                    end
                end
                
                // State transition
                if (cnt == 0) begin
                    major_state <= MAJOR_YELLOW;
                    cnt <= 5;
                end else begin
                    cnt <= cnt - 1;
                end
            end
        endcase
    end
end

// Output logic - one-hot encoded
assign red = (major_state == MAJOR_RED);
assign yellow = (major_state == MAJOR_YELLOW);
assign green = (major_state == MAJOR_GREEN);
assign clock = {2'b00, cnt};

// Watchdog timer (optional safety feature)
reg [3:0] watchdog;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        watchdog <= 0;
    end else if (|{red, yellow, green}) begin
        watchdog <= 0;
    end else if (watchdog == 15) begin
        // Force safe state if no lights are on
        major_state <= MAJOR_RED;
        cnt <= 10;
        watchdog <= 0;
    end else begin
        watchdog <= watchdog + 1;
    end
end

endmodule