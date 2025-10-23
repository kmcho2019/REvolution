module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output red,
    output yellow,
    output green
);

// Fixed timing parameters
localparam GREEN_TIME  = 60;
localparam YELLOW_TIME = 5;
localparam RED_TIME    = 10;
localparam MIN_GREEN   = 10;

// State encoding
reg [1:0] state;
reg [5:0] cnt;

// State definitions
localparam RED    = 2'b00;
localparam YELLOW = 2'b01;
localparam GREEN  = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset to RED state with full count
        state <= RED;
        cnt <= RED_TIME;
    end else begin
        // Counter management
        if (cnt == 0) begin
            // State transition when counter expires
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
        end else begin
            // Handle pedestrian request during green
            if (state == GREEN && pass_request && cnt > MIN_GREEN) begin
                cnt <= MIN_GREEN;
            end else begin
                cnt <= cnt - 1;
            end
        end
    end
end

// Direct output assignments
assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);
assign clock  = cnt;

endmodule