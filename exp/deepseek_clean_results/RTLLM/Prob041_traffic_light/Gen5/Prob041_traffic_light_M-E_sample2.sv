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
parameter REQ_DEBOUNCE = 5;  // Pedestrian request hysteresis

// One-hot state encoding
localparam [2:0] 
    IDLE  = 3'b000,
    RED_S = 3'b001,
    YELLOW_S = 3'b010,
    GREEN_S = 3'b100;

reg [2:0] state, next_state;

// Parallel counters
reg [7:0] red_cnt, yellow_cnt, green_cnt;
reg [7:0] req_debounce;

// Time banking register
reg [7:0] time_bank;

// Output registers
reg r_red, r_yellow, r_green;

// Active counter selection
wire [7:0] active_counter = 
    (state[0]) ? red_cnt :
    (state[1]) ? yellow_cnt :
    green_cnt;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        red_cnt <= RED_TIME;
        yellow_cnt <= YELLOW_TIME;
        green_cnt <= GREEN_TIME;
        time_bank <= 0;
        req_debounce <= 0;
    end else begin
        state <= next_state;
        
        // Update counters in parallel
        if (state[0] && red_cnt > 0) red_cnt <= red_cnt - 1;
        if (state[1] && yellow_cnt > 0) yellow_cnt <= yellow_cnt - 1;
        if (state[2] && green_cnt > 0) green_cnt <= green_cnt - 1;
        
        // Handle pedestrian request with debouncing
        if (pass_request) req_debounce <= REQ_DEBOUNCE;
        else if (req_debounce > 0) req_debounce <= req_debounce - 1;
        
        // Time banking logic
        if (state[2] && req_debounce > 0 && green_cnt > MIN_GREEN) begin
            time_bank <= green_cnt - MIN_GREEN;
            green_cnt <= MIN_GREEN;
        end else if (next_state[2] && time_bank > 0) begin
            // Return borrowed time in next green phase
            green_cnt <= green_cnt + time_bank;
            time_bank <= 0;
        end
        
        // Counter reload logic
        if (next_state[0]) begin
            red_cnt <= RED_TIME;
            if (time_bank > 0) green_cnt <= GREEN_TIME + time_bank;
        end
        if (next_state[1]) yellow_cnt <= YELLOW_TIME;
        if (next_state[2]) green_cnt <= GREEN_TIME;
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    case (1'b1)  // Synopsys parallel_case
        state[0]: if (red_cnt == 1) next_state = GREEN_S;
        state[1]: if (yellow_cnt == 1) next_state = RED_S;
        state[2]: if (green_cnt == 1) next_state = YELLOW_S;
        default: next_state = RED_S;  // IDLE -> RED
    endcase
end

// Output generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r_red <= 0;
        r_yellow <= 0;
        r_green <= 0;
    end else begin
        r_red <= state[0];
        r_yellow <= state[1];
        r_green <= state[2];
    end
end

assign clock = active_counter;
assign red = r_red;
assign yellow = r_yellow;
assign green = r_green;

endmodule