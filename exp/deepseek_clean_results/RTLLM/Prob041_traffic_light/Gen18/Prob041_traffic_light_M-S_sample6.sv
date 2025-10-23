module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1;
        yellow <= 0;
        green <= 0;
        clock <= RED_TIME;
    end else begin
        // Handle counter and state transitions
        if (clock == 1) begin
            if (red) begin
                red <= 0;
                green <= 1;
                clock <= GREEN_TIME;
            end else if (yellow) begin
                yellow <= 0;
                red <= 1;
                clock <= RED_TIME;
            end else if (green) begin
                green <= 0;
                yellow <= 1;
                clock <= YELLOW_TIME;
            end
        end else begin
            // Handle pedestrian request and counter decrement
            clock <= (green && pass_request && (clock > MIN_GREEN)) ? MIN_GREEN : clock - 1;
        end
    end
end

endmodule