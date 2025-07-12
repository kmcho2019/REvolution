module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output red,
    output yellow,
    output green
);

parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// State encoding
parameter S_RED    = 2'b00;
parameter S_YELLOW = 2'b01;
parameter S_GREEN  = 2'b10;

reg [1:0] state, next_state;
reg [5:0] counter, next_counter;

// State transition logic
always @(*) begin
    next_state = state;
    next_counter = counter;
    
    if (!rst_n) begin
        next_state = S_RED;
        next_counter = RED_TIME;
    end else begin
        if (counter == 1) begin
            case (state)
                S_RED: begin
                    next_state = S_GREEN;
                    next_counter = GREEN_TIME;
                end
                S_YELLOW: begin
                    next_state = S_RED;
                    next_counter = RED_TIME;
                end
                S_GREEN: begin
                    next_state = S_YELLOW;
                    next_counter = YELLOW_TIME;
                end
            endcase
        end else begin
            // Handle pedestrian request
            if (state == S_GREEN && pass_request && counter > MIN_GREEN)
                next_counter = MIN_GREEN;
            else
                next_counter = counter - 1;
        end
    end
end

// Sequential state update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S_RED;
        counter <= RED_TIME;
    end else begin
        state <= next_state;
        counter <= next_counter;
    end
end

// Output generation
assign red = (state == S_RED);
assign yellow = (state == S_YELLOW);
assign green = (state == S_GREEN);
assign clock = counter;

endmodule