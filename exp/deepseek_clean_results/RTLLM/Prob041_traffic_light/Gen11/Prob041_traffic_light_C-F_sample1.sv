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
reg [1:0] state;
reg [5:0] cnt;

// State definitions
localparam RED    = 2'b00;
localparam YELLOW = 2'b01;
localparam GREEN  = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
    end else begin
        // Decrement counter first
        cnt <= cnt - 1;
        
        // State transition and counter reset logic
        case (state)
            RED: begin
                if (cnt == 1) begin
                    state <= GREEN;
                    cnt <= GREEN_TIME;
                end
            end
            YELLOW: begin
                if (cnt == 1) begin
                    state <= RED;
                    cnt <= RED_TIME;
                end
            end
            GREEN: begin
                // Handle pedestrian request
                if (pass_request && cnt > MIN_GREEN) begin
                    cnt <= MIN_GREEN;
                end
                // State transition
                if (cnt == 1) begin
                    state <= YELLOW;
                    cnt <= YELLOW_TIME;
                end
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