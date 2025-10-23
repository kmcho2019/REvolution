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
parameter TOTAL_CYCLE = 8'd75;  // 60G + 5Y + 10R
parameter GREEN_START = 8'd0;
parameter GREEN_END   = 8'd60;
parameter YELLOW_END  = 8'd65;
parameter MIN_GREEN   = 8'd10;

// Internal signals
reg [7:0] cycle_counter;
wire [7:0] next_counter = (cycle_counter == TOTAL_CYCLE-1) ? 8'd0 : cycle_counter + 1;
wire in_green = (cycle_counter < GREEN_END);
wire in_yellow = (cycle_counter >= GREEN_END && cycle_counter < YELLOW_END);
wire in_red = (cycle_counter >= YELLOW_END);

// Pedestrian request handling
wire pedestrian_trigger = pass_request && in_green && 
                         ((GREEN_END - cycle_counter) > MIN_GREEN);
wire [7:0] forced_counter = GREEN_END - MIN_GREEN;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cycle_counter <= 8'd0;
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        // Handle pedestrian request by forcing counter
        if (pedestrian_trigger) begin
            cycle_counter <= forced_counter;
        end else begin
            cycle_counter <= next_counter;
        end

        // Output generation
        red <= in_red;
        yellow <= in_yellow;
        green <= in_green && !pedestrian_trigger;
    end
end

assign clock = cycle_counter;

endmodule