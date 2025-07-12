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

// One-hot state encoding
localparam RED    = 3'b001;
localparam YELLOW = 3'b010;
localparam GREEN  = 3'b100;

reg [2:0] state;
reg [5:0] cnt;
reg cnt_en;  // Counter enable signal for clock gating

// Next state and counter value
wire [2:0] next_state;
wire [5:0] next_cnt;

// Combinational logic for state transitions and counter
always @(*) begin
    if (cnt == 0) begin
        case (state)
            RED: begin
                next_state = GREEN;
                next_cnt = GREEN_TIME;
            end
            YELLOW: begin
                next_state = RED;
                next_cnt = RED_TIME;
            end
            GREEN: begin
                next_state = YELLOW;
                next_cnt = YELLOW_TIME;
            end
            default: begin
                next_state = RED;
                next_cnt = RED_TIME;
            end
        endcase
    end else begin
        next_state = state;
        // Handle pedestrian request
        if (pass_request && (state == GREEN) && (cnt > MIN_GREEN))
            next_cnt = MIN_GREEN;
        else
            next_cnt = cnt - 1;
    end
end

// Sequential logic with clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
        cnt_en <= 1'b1;
    end else begin
        state <= next_state;
        cnt <= next_cnt;
        // Enable counter only when needed
        cnt_en <= (next_cnt != 0) || (next_state != state);
    end
end

// Gated clock for counter (conceptual - actual implementation depends on library)
wire gated_clk = clk & cnt_en;

// Output assignments (direct from one-hot encoding)
assign red = state[0];
assign yellow = state[1];
assign green = state[2];
assign clock = cnt;

endmodule