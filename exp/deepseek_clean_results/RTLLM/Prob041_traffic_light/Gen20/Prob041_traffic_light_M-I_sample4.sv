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

// One-hot state definitions
localparam RED    = 3'b001;
localparam YELLOW = 3'b010;
localparam GREEN  = 3'b100;

reg [2:0] state;
reg [5:0] cnt;
reg cnt_en;  // Counter enable signal

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
        cnt_en <= 1'b1;
    end else begin
        cnt_en <= 1'b1;  // Default enable
        
        if (cnt == 0) begin
            // State transitions
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
                default: state <= RED;
            endcase
        end else begin
            // Handle pedestrian request only in GREEN state
            if (state[2] && pass_request && cnt > MIN_GREEN) begin
                cnt <= MIN_GREEN;
            end
            // Disable counter when light is stable and no requests
            else if (state[2] && cnt == MIN_GREEN && !pass_request) begin
                cnt_en <= 1'b0;
            end
        end
    end
end

// Clock gated counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else if (cnt_en) begin
        cnt <= cnt - 1;
    end
end

// Direct output assignments from one-hot state
assign red = state[0];
assign yellow = state[1];
assign green = state[2];
assign clock = cnt;

endmodule