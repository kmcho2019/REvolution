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
typedef enum logic [1:0] {
    ST_RED,
    ST_YELLOW,
    ST_GREEN
} state_t;

state_t current_state, next_state;
reg [7:0] counter;

// Continuous output assignments
assign red    = (current_state == ST_RED);
assign yellow = (current_state == ST_YELLOW);
assign green  = (current_state == ST_GREEN);
assign clock  = counter;

// Counter control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= RED_TIME;
    end else begin
        if (counter == 0) begin
            case (current_state)
                ST_RED:    counter <= GREEN_TIME;
                ST_YELLOW: counter <= RED_TIME;
                ST_GREEN:  counter <= YELLOW_TIME;
            endcase
        end else if (pass_request && green && (counter > MIN_GREEN)) begin
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

// Next state logic
always @(*) begin
    next_state = current_state;
    if (counter == 0) begin
        case (current_state)
            ST_RED:    next_state = ST_GREEN;
            ST_YELLOW: next_state = ST_RED;
            ST_GREEN:  next_state = ST_YELLOW;
        endcase
    end
end

endmodule