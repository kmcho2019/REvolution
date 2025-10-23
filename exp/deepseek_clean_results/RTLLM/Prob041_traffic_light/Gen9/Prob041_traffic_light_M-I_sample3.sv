module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,  // Reduced from 8 to 6 bits
    output red,
    output yellow,
    output green
);

// Timing parameters
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// One-hot state encoding
typedef enum logic [2:0] {
    ST_RED    = 3'b001,
    ST_YELLOW = 3'b010,
    ST_GREEN  = 3'b100
} state_t;

state_t current_state, next_state;
reg [5:0] counter;  // 6-bit counter sufficient for max 60 cycles
reg pass_request_sync;
wire counter_enable;

// Synchronize pass_request
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pass_request_sync <= 1'b0;
    end else begin
        pass_request_sync <= pass_request;
    end
end

// Clock gating for counter
assign counter_enable = (counter != 0) || 
                       (current_state == ST_RED && next_state == ST_GREEN) ||
                       (current_state == ST_YELLOW && next_state == ST_RED) ||
                       (current_state == ST_GREEN && next_state == ST_YELLOW);

// Continuous output assignments
assign red    = (current_state == ST_RED);
assign yellow = (current_state == ST_YELLOW);
assign green  = (current_state == ST_GREEN);
assign clock  = counter;

// Counter control with gated clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= RED_TIME;
    end else if (counter_enable) begin
        if (counter == 0) begin
            case (current_state)
                ST_RED:    counter <= GREEN_TIME;
                ST_YELLOW: counter <= RED_TIME;
                ST_GREEN:  counter <= YELLOW_TIME;
            endcase
        end else if (pass_request_sync && green && (counter > MIN_GREEN)) begin
            counter <= MIN_GREEN;
        end else begin
            counter <= counter - 1;
        end
    end
end

// State transition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= ST_RED;
    end else begin
        current_state <= next_state;
    end
end

// Optimized next state logic with shared comparator
wire counter_zero = (counter == 0);
always @(*) begin
    next_state = current_state;
    if (counter_zero) begin
        case (current_state)
            ST_RED:    next_state = ST_GREEN;
            ST_YELLOW: next_state = ST_RED;
            ST_GREEN:  next_state = ST_YELLOW;
        endcase
    end
end

endmodule