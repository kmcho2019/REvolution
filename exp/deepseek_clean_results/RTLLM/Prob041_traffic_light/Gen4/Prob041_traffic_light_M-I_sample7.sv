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

// State encoding (2 bits)
parameter [1:0] IDLE  = 2'b00;
parameter [1:0] RED   = 2'b01;
parameter [1:0] YELLOW = 2'b10;
parameter [1:0] GREEN = 2'b11;

reg [1:0] state, next_state;
reg [5:0] cnt;  // Reduced from 8 to 6 bits
reg pass_request_sync;
reg counter_en;

// Output registers (only update on state changes)
reg r_red, r_yellow, r_green;

// Clock gating logic
wire gated_clk = clk & counter_en;

// Synchronize pass_request
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pass_request_sync <= 1'b0;
    end else begin
        pass_request_sync <= pass_request;
    end
end

// State transition and output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        r_red <= 1'b0;
        r_yellow <= 1'b0;
        r_green <= 1'b0;
    end else begin
        state <= next_state;
        
        // Update outputs only when state changes
        if (state != next_state) begin
            r_red <= (next_state == RED);
            r_yellow <= (next_state == YELLOW);
            r_green <= (next_state == GREEN);
        end
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    case (state)
        IDLE:   next_state = RED;
        RED:    if (cnt == 0) next_state = GREEN;
        YELLOW: if (cnt == 0) next_state = RED;
        GREEN:  if (cnt == 0) next_state = YELLOW;
    endcase
end

// Counter enable logic
always @(*) begin
    counter_en = 1'b1;
    if (state == GREEN && cnt > MIN_GREEN && !pass_request_sync)
        counter_en = 1'b0;
end

// Counter management (using gated clock)
always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else begin
        // Handle pedestrian request
        if (pass_request_sync && (state == GREEN) && (cnt > MIN_GREEN)) begin
            cnt <= MIN_GREEN;
        end
        // State transition counter updates
        else if (cnt == 0) begin
            case (state)
                RED:    cnt <= GREEN_TIME;
                YELLOW: cnt <= RED_TIME;
                GREEN:  cnt <= YELLOW_TIME;
                default: cnt <= RED_TIME;
            endcase
        end else begin
            cnt <= cnt - 1;
        end
    end
end

// Output assignments
assign clock = cnt;
assign red = r_red;
assign yellow = r_yellow;
assign green = r_green;

endmodule