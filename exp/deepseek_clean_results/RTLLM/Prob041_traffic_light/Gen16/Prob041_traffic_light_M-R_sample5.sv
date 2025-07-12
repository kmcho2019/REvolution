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
localparam GREEN_TIME = 60;
localparam YELLOW_TIME = 5;
localparam RED_TIME = 10;
localparam MIN_GREEN = 10;

// State encoding
reg [1:0] state, next_state;
reg [5:0] cnt;

// State definitions
localparam RED    = 2'b00;
localparam YELLOW = 2'b01;
localparam GREEN  = 2'b10;

// State transition logic (combinational)
always @(*) begin
    next_state = state;
    case (state)
        RED:    if (cnt == 1) next_state = GREEN;
        YELLOW: if (cnt == 1) next_state = RED;
        GREEN:  if (cnt == 1) next_state = YELLOW;
    endcase
end

// State storage (sequential)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
    end else begin
        state <= next_state;
    end
end

// Counter logic (sequential)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else begin
        // Handle pedestrian request during green phase
        if (state == GREEN && pass_request && cnt > MIN_GREEN) begin
            cnt <= MIN_GREEN;
        end
        // Normal counter operation
        else if (cnt > 1) begin
            cnt <= cnt - 1;
        end
        // State transition counter reset
        else begin
            case (next_state)
                RED:    cnt <= RED_TIME;
                YELLOW: cnt <= YELLOW_TIME;
                GREEN: cnt <= GREEN_TIME;
            endcase
        end
    end
end

// Output assignments
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);
assign clock = cnt;

endmodule