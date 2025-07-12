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
parameter GREEN_DURATION  = 60;
parameter YELLOW_DURATION = 5;
parameter RED_DURATION    = 10;
parameter MIN_GREEN_TIME  = 10;

// State encoding
parameter [1:0] RED_ST    = 2'b00;
parameter [1:0] YELLOW_ST = 2'b01;
parameter [1:0] GREEN_ST  = 2'b10;

reg [1:0] current_state, next_state;
reg [5:0] cnt;
reg [5:0] next_cnt;

// State transition logic (combinatorial)
always @(*) begin
    next_state = current_state;
    next_cnt = cnt;
    
    case (current_state)
        RED_ST: begin
            if (cnt == 1) begin
                next_state = GREEN_ST;
                next_cnt = GREEN_DURATION;
            end else begin
                next_cnt = cnt - 1;
            end
        end
        
        YELLOW_ST: begin
            if (cnt == 1) begin
                next_state = RED_ST;
                next_cnt = RED_DURATION;
            end else begin
                next_cnt = cnt - 1;
            end
        end
        
        GREEN_ST: begin
            // Handle pedestrian request
            if (pass_request && cnt > MIN_GREEN_TIME) begin
                next_cnt = MIN_GREEN_TIME;
            end
            // State transition
            else if (cnt == 1) begin
                next_state = YELLOW_ST;
                next_cnt = YELLOW_DURATION;
            end else begin
                next_cnt = cnt - 1;
            end
        end
        
        default: begin
            next_state = RED_ST;
            next_cnt = RED_DURATION;
        end
    endcase
end

// Sequential state and counter update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= RED_ST;
        cnt <= RED_DURATION;
    end else begin
        current_state <= next_state;
        cnt <= next_cnt;
    end
end

// Output assignments
assign red    = (current_state == RED_ST);
assign yellow = (current_state == YELLOW_ST);
assign green  = (current_state == GREEN_ST);
assign clock  = cnt;

endmodule