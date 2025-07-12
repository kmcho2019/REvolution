module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Gray-coded state encoding for power efficiency
parameter [1:0] RED_ST    = 2'b00;
parameter [1:0] YELLOW_ST = 2'b01;
parameter [1:0] GREEN_ST  = 2'b11;

reg [1:0] current_state, next_state;
reg [5:0] timer;
reg [5:0] next_timer;
reg handle_request;

// Time constants
parameter GREEN_TIME  = 6'd60;
parameter YELLOW_TIME = 6'd5;
parameter RED_TIME    = 6'd10;
parameter REQ_TIME    = 6'd10;

// Output assignment
assign clock = timer;

// Gray-coded state transition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= RED_ST;
        timer <= RED_TIME;
    end else begin
        current_state <= next_state;
        timer <= next_timer;
    end
end

// Main state machine
always @(*) begin
    // Default values
    next_state = current_state;
    next_timer = timer;
    handle_request = 1'b0;
    
    case (current_state)
        RED_ST: begin
            red = 1'b1;
            yellow = 1'b0;
            green = 1'b0;
            
            if (timer == 6'd1) begin
                next_state = GREEN_ST;
                next_timer = GREEN_TIME;
            end else begin
                next_timer = timer - 6'd1;
            end
        end
        
        YELLOW_ST: begin
            red = 1'b0;
            yellow = 1'b1;
            green = 1'b0;
            
            if (timer == 6'd1) begin
                next_state = RED_ST;
                next_timer = RED_TIME;
            end else begin
                next_timer = timer - 6'd1;
            end
        end
        
        GREEN_ST: begin
            red = 1'b0;
            yellow = 1'b0;
            green = 1'b1;
            
            // Handle pedestrian request
            if (pass_request && timer > REQ_TIME) begin
                next_timer = REQ_TIME;
                handle_request = 1'b1;
            end
            
            if (timer == 6'd1) begin
                next_state = YELLOW_ST;
                next_timer = YELLOW_TIME;
            end else if (!handle_request) begin
                next_timer = timer - 6'd1;
            end
        end
        
        default: begin
            red = 1'b0;
            yellow = 1'b0;
            green = 1'b0;
            next_state = RED_ST;
            next_timer = RED_TIME;
        end
    endcase
end

endmodule