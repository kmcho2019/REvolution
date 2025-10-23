module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Timing parameters
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// State encoding
parameter RED    = 2'b00;
parameter YELLOW = 2'b01;
parameter GREEN  = 2'b10;

reg [1:0] state;
reg [7:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
        {red, yellow, green} <= 3'b100;
    end else begin
        // Default outputs
        {red, yellow, green} <= 3'b000;
        
        // State and counter logic
        case (state)
            RED: begin
                red <= 1'b1;
                if (cnt == 1) begin
                    state <= GREEN;
                    cnt <= GREEN_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            YELLOW: begin
                yellow <= 1'b1;
                if (cnt == 1) begin
                    state <= RED;
                    cnt <= RED_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            GREEN: begin
                green <= 1'b1;
                // Handle pedestrian request
                if (pass_request && cnt > MIN_GREEN) begin
                    cnt <= MIN_GREEN;
                end
                // State transition
                if (cnt == 1) begin
                    state <= YELLOW;
                    cnt <= YELLOW_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            default: begin
                state <= RED;
                cnt <= RED_TIME;
            end
        endcase
    end
end

assign clock = cnt;

endmodule