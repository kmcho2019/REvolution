module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [6:0] clock,
    output red,
    output yellow,
    output green
);

// Timing parameters
parameter GREEN_TIME  = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME    = 10;
parameter MIN_GREEN   = 10;

// State encoding
reg [1:0] state;
reg [6:0] cnt;
reg counter_en;  // Clock gating control

// State definitions
localparam RED    = 2'b00;
localparam YELLOW = 2'b01;
localparam GREEN  = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
        counter_en <= 1'b1;
    end else begin
        // Clock gating logic
        counter_en <= (cnt > 1) || (state == GREEN && pass_request && cnt > MIN_GREEN);

        // Handle state transitions and counter updates
        if (counter_en) begin
            if (state == GREEN && pass_request && cnt > MIN_GREEN) begin
                cnt <= MIN_GREEN;
            end else if (cnt > 1) begin
                cnt <= cnt - 1;
            end else begin
                // State transitions when counter reaches 1
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
end

// Direct output assignments
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);
assign clock = cnt;

endmodule