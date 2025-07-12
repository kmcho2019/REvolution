module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Timing parameters
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// Gray-coded state encoding (minimizes switching)
localparam [1:0] RED_S    = 2'b00;
localparam [1:0] YELLOW_S = 2'b01;
localparam [1:0] GREEN_S  = 2'b11;
localparam [1:0] IDLE_S   = 2'b10;

reg [1:0] state, next_state;
reg [7:0] cnt;
reg [7:0] green_cnt;
reg early_terminate;

// Parallel counters approach
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED_S;
        cnt <= RED_TIME;
        green_cnt <= GREEN_TIME;
        early_terminate <= 0;
    end else begin
        state <= next_state;
        
        // Main counter always decrements
        cnt <= cnt - 1;
        
        // Special green counter for pedestrian requests
        if (state == GREEN_S) begin
            green_cnt <= green_cnt - 1;
            if (pass_request && (green_cnt > MIN_GREEN)) begin
                early_terminate <= 1;
                cnt <= MIN_GREEN;
                green_cnt <= MIN_GREEN;
            end
        end else begin
            green_cnt <= GREEN_TIME;
            early_terminate <= 0;
        end
    end
end

// Next state logic with predictive timing
always @(*) begin
    case (state)
        RED_S: begin
            next_state = (cnt == 1) ? GREEN_S : RED_S;
            if (cnt == 1) cnt = GREEN_TIME;
        end
        YELLOW_S: begin
            next_state = (cnt == 1) ? RED_S : YELLOW_S;
            if (cnt == 1) cnt = RED_TIME;
        end
        GREEN_S: begin
            next_state = (cnt == 1) ? YELLOW_S : GREEN_S;
            if (cnt == 1) cnt = YELLOW_TIME;
        end
        default: begin // IDLE_S
            next_state = RED_S;
            cnt = RED_TIME;
        end
    endcase
end

// Shadow registers for glitch-free outputs
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1;
        yellow <= 0;
        green <= 0;
    end else begin
        red <= (next_state == RED_S);
        yellow <= (next_state == YELLOW_S);
        green <= (next_state == GREEN_S);
    end
end

// Output the appropriate counter value
assign clock = (state == GREEN_S) ? green_cnt : cnt;

endmodule