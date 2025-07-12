module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Timing parameters
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// Gray-coded state definitions
localparam [1:0] 
    S_RED    = 2'b00,
    S_YELLOW = 2'b01,
    S_GREEN  = 2'b11;

reg [1:0] current_state, next_state;
reg [5:0] next_count;
reg count_enable;
wire count_done = (clock == 1);

// Main state machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= S_RED;
        clock <= RED_TIME;
        {red, yellow, green} <= 3'b100;
    end else begin
        current_state <= next_state;
        clock <= next_count;
        
        // Registered outputs
        case (next_state)
            S_RED:    {red, yellow, green} <= 3'b100;
            S_YELLOW: {red, yellow, green} <= 3'b010;
            S_GREEN:  {red, yellow, green} <= 3'b001;
        endcase
    end
end

// Next state and counter logic
always @(*) begin
    // Default assignments
    next_state = current_state;
    next_count = clock;
    count_enable = 1'b1;
    
    // Handle pedestrian request during green phase
    if (current_state == S_GREEN && pass_request && clock > MIN_GREEN) begin
        next_count = MIN_GREEN;
        count_enable = 1'b1;
    end
    
    // State transition logic
    if (count_done) begin
        count_enable = 1'b0;
        case (current_state)
            S_RED: begin
                next_state = S_GREEN;
                next_count = GREEN_TIME;
            end
            S_YELLOW: begin
                next_state = S_RED;
                next_count = RED_TIME;
            end
            S_GREEN: begin
                next_state = S_YELLOW;
                next_count = YELLOW_TIME;
            end
        endcase
    end else if (count_enable) begin
        next_count = clock - 1;
    end
end

// Clock gating for power optimization
reg gated_clk;
always @(*) begin
    gated_clk = clk & count_enable;
end

endmodule