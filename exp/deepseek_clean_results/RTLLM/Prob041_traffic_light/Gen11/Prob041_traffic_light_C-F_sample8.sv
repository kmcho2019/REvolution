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
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// State encoding
parameter IDLE  = 2'b00;
parameter RED   = 2'b01;
parameter YELLOW = 2'b10;
parameter GREEN = 2'b11;

reg [1:0] state;
reg [5:0] cnt;

// Combined state and counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
    end else begin
        case (state)
            RED: begin
                if (cnt == 1) begin
                    state <= GREEN;
                    cnt <= GREEN_TIME;
                end else
                    cnt <= cnt - 1;
            end
            
            YELLOW: begin
                if (cnt == 1) begin
                    state <= RED;
                    cnt <= RED_TIME;
                end else
                    cnt <= cnt - 1;
            end
            
            GREEN: begin
                // Handle pedestrian request
                if (pass_request && (cnt > MIN_GREEN))
                    cnt <= MIN_GREEN;
                    
                if (cnt == 1) begin
                    state <= YELLOW;
                    cnt <= YELLOW_TIME;
                end else
                    cnt <= cnt - 1;
            end
            
            default: begin // IDLE
                state <= RED;
                cnt <= RED_TIME;
            end
        endcase
    end
end

// Output assignments
assign clock = cnt;
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);

endmodule