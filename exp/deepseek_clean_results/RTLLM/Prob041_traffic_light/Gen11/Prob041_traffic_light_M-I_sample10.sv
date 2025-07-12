module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output reg [1:0] light // 00:red, 01:yellow, 10:green
);

// Timing parameters
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// Gray-coded state encoding
localparam [1:0] 
    IDLE  = 2'b00,
    RED   = 2'b01,
    YELLOW = 2'b11,
    GREEN = 2'b10;

reg [1:0] state, next_state;
reg [5:0] cnt;
reg cnt_en; // Counter enable for clock gating

// State transition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state and output logic
always @(*) begin
    // Default outputs
    light = 2'b00; // Red by default
    next_state = state;
    cnt_en = 1'b1; // Enable counter by default
    
    case (state)
        IDLE: begin
            next_state = RED;
            cnt_en = 1'b0; // Disable counter during idle
        end
        
        RED: begin
            light = 2'b00; // Red
            if (cnt == 1) next_state = GREEN;
        end
        
        YELLOW: begin
            light = 2'b01; // Yellow
            if (cnt == 1) next_state = RED;
        end
        
        GREEN: begin
            light = 2'b10; // Green
            if (cnt == 1) next_state = YELLOW;
            // Only evaluate pass_request when needed
            if (pass_request && (cnt > MIN_GREEN)) begin
                cnt_en = 1'b0; // Disable counter during forced transition
            end
        end
    endcase
end

// Counter management with synchronous load and clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else if (cnt_en) begin
        if (pass_request && (state == GREEN) && (cnt > MIN_GREEN)) begin
            cnt <= MIN_GREEN;
        end
        else if (cnt == 1) begin
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

assign clock = cnt;

endmodule