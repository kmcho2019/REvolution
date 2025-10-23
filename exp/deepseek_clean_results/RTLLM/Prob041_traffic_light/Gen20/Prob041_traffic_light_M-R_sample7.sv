module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output red,
    output yellow,
    output green
);

// Timing parameters
parameter GREEN_TIME  = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME    = 10;
parameter MIN_GREEN   = 10;

// State encoding
localparam RED    = 2'b00;
localparam YELLOW = 2'b01;
localparam GREEN  = 2'b10;

reg [1:0] current_state, next_state;
reg [5:0] cnt;
wire counter_expired = (cnt == 0);
wire pedestrian_override = (pass_request && (current_state == GREEN) && (cnt > MIN_GREEN));

// State transition logic
always @(*) begin
    case (current_state)
        RED:    next_state = counter_expired ? GREEN : RED;
        YELLOW: next_state = counter_expired ? RED : YELLOW;
        GREEN:  next_state = counter_expired ? YELLOW : GREEN;
        default: next_state = RED;
    endcase
end

// State register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= RED;
    end else begin
        current_state <= next_state;
    end
end

// Counter control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else if (pedestrian_override) begin
        cnt <= MIN_GREEN;
    end else if (counter_expired) begin
        case (next_state)
            RED:    cnt <= RED_TIME;
            YELLOW: cnt <= YELLOW_TIME;
            GREEN:  cnt <= GREEN_TIME;
            default: cnt <= RED_TIME;
        endcase
    end else begin
        cnt <= cnt - 1;
    end
end

// Output assignments
assign red    = (current_state == RED);
assign yellow = (current_state == YELLOW);
assign green  = (current_state == GREEN);
assign clock  = cnt;

endmodule