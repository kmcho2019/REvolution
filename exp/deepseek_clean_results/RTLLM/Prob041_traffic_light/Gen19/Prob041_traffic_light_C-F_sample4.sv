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
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// State definitions
localparam RED    = 2'b00;
localparam YELLOW = 2'b01;
localparam GREEN  = 2'b10;

reg [1:0] current_state, next_state;
reg [5:0] cnt;
wire counter_enable;  // Clock gating hint

// State transition logic (combinational)
always @(*) begin
    next_state = current_state;
    case (current_state)
        RED:    if (cnt == 1) next_state = GREEN;
        YELLOW: if (cnt == 1) next_state = RED;
        GREEN:  if (cnt == 1) next_state = YELLOW;
    endcase
end

// Counter enable logic (reduces power)
assign counter_enable = (cnt > 1) || 
                       (current_state == RED && cnt == 1) ||
                       (current_state == YELLOW && cnt == 1) ||
                       (current_state == GREEN && cnt == 1);

// Sequential logic (state + counter)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= RED;
        cnt <= RED_TIME;
    end else begin
        current_state <= next_state;
        
        // Handle pedestrian request during green
        if (pass_request && (current_state == GREEN) && (cnt > MIN_GREEN))
            cnt <= MIN_GREEN;
        // Load new counter value on state transition
        else if (cnt == 1) begin
            case (next_state)
                RED:    cnt <= RED_TIME;
                YELLOW: cnt <= YELLOW_TIME;
                GREEN:  cnt <= GREEN_TIME;
            endcase
        end
        // Conditional countdown
        else if (counter_enable)
            cnt <= cnt - 1;
    end
end

// Output assignments
assign clock = cnt;
assign red = (current_state == RED);
assign yellow = (current_state == YELLOW);
assign green = (current_state == GREEN);

endmodule