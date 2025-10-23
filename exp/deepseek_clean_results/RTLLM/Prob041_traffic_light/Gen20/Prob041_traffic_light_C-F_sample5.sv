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
        // Reset to RED state with full duration
        state <= RED;
        cnt <= RED_TIME;
    end else begin
        // Handle pedestrian request first (priority)
        if (state == GREEN && pass_request && cnt > MIN_GREEN)
            cnt <= MIN_GREEN;
        
        // Counter and state transition logic
        if (cnt > 1) begin
            cnt <= cnt - 1;
        end else begin
            case (state)
                RED: begin
                    state <= GREEN;
                    cnt <= GREEN_TIME;
                end
                YELLOW: begin
                    state <= RED;
                    cnt <= RED_TIME;
                end
                GREEN: begin
                    state <= YELLOW;
                    cnt <= YELLOW_TIME;
                end
            endcase
        end
    end
end

// Direct output assignments
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);
assign clock = cnt;

endmodule