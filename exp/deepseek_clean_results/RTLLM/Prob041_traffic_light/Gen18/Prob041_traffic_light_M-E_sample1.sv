module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Configurable timing parameters
parameter GREEN_TIME  = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME    = 10;
parameter MIN_GREEN   = 10;

// Gray-coded state definitions
typedef enum logic [1:0] {
    RED_ST    = 2'b00,
    YELLOW_ST = 2'b01,
    GREEN_ST  = 2'b11
} state_t;

// Internal signals
state_t current_state, next_state;
reg [7:0] next_count;
reg pass_request_sync, pass_request_edge;
reg [1:0] sync_reg;

// Edge detection for pedestrian request
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sync_reg <= 2'b00;
        pass_request_sync <= 1'b0;
        pass_request_edge <= 1'b0;
    end else begin
        sync_reg <= {sync_reg[0], pass_request};
        pass_request_sync <= sync_reg[1];
        pass_request_edge <= sync_reg[1] & ~pass_request_sync;
    end
end

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= RED_ST;
        clock <= RED_TIME;
    end else begin
        current_state <= next_state;
        clock <= next_count;
    end
end

// Next state and counter logic
always_comb begin
    // Default assignments
    next_state = current_state;
    next_count = clock - 1'b1;
    
    // State transitions and counter loading
    case (current_state)
        RED_ST: begin
            if (clock == 0) begin
                next_state = GREEN_ST;
                next_count = GREEN_TIME;
            end
        end
        
        YELLOW_ST: begin
            if (clock == 0) begin
                next_state = RED_ST;
                next_count = RED_TIME;
            end
        end
        
        GREEN_ST: begin
            // Handle pedestrian request
            if (pass_request_edge && (clock > MIN_GREEN)) begin
                next_count = MIN_GREEN;
            end
            else if (clock == 0) begin
                next_state = YELLOW_ST;
                next_count = YELLOW_TIME;
            end
        end
    endcase
end

// Registered output generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red    <= 1'b1;
        yellow <= 1'b0;
        green  <= 1'b0;
    end else begin
        red    <= (current_state == RED_ST);
        yellow <= (current_state == YELLOW_ST);
        green  <= (current_state == GREEN_ST);
    end
end

endmodule