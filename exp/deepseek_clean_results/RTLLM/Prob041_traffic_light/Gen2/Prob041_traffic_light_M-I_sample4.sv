module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State definitions
typedef enum logic [1:0] {
    IDLE,
    RED,
    YELLOW,
    GREEN
} state_t;

// Duration parameters
parameter RED_DURATION = 10;
parameter YELLOW_DURATION = 5;
parameter GREEN_DURATION = 60;
parameter MIN_GREEN = 10;

// Internal signals
state_t current_state;
reg [7:0] counter;
reg pass_request_sync;

// Synchronize pedestrian request
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pass_request_sync <= 0;
    end else begin
        pass_request_sync <= pass_request;
    end
end

// Main state machine and counter control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        counter <= RED_DURATION;
        {red, yellow, green} <= 3'b000;
    end
    else begin
        case (current_state)
            IDLE: begin
                current_state <= RED;
                counter <= RED_DURATION;
                {red, yellow, green} <= 3'b100;
            end
            
            RED: begin
                if (counter == 0) begin
                    current_state <= GREEN;
                    counter <= GREEN_DURATION;
                    {red, yellow, green} <= 3'b001;
                end
                else begin
                    counter <= counter - 1;
                end
            end
            
            YELLOW: begin
                if (counter == 0) begin
                    current_state <= RED;
                    counter <= RED_DURATION;
                    {red, yellow, green} <= 3'b100;
                end
                else begin
                    counter <= counter - 1;
                end
            end
            
            GREEN: begin
                // Handle pedestrian request
                if (pass_request_sync && counter > MIN_GREEN) begin
                    counter <= MIN_GREEN;
                end
                
                if (counter == 0) begin
                    current_state <= YELLOW;
                    counter <= YELLOW_DURATION;
                    {red, yellow, green} <= 3'b010;
                end
                else begin
                    counter <= counter - 1;
                end
            end
        endcase
    end
end

// Output counter value
always @(posedge clk) begin
    clock <= counter;
end

endmodule