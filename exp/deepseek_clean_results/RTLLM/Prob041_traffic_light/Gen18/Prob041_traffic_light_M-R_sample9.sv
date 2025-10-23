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

// State definitions
localparam RED    = 2'b00;
localparam YELLOW = 2'b01;
localparam GREEN  = 2'b10;

reg [1:0] state;
reg [5:0] cnt;

// Combinational state transitions
wire to_red    = (state == YELLOW) && (cnt == 1);
wire to_yellow = (state == GREEN)  && (cnt == 1);
wire to_green  = (state == RED)    && (cnt == 1);

// Pedestrian request handling
wire pedestrian_override = pass_request && (state == GREEN) && (cnt > MIN_GREEN);

// Counter load values
wire [5:0] next_cnt = (state == RED)    ? RED_TIME :
                      (state == YELLOW) ? YELLOW_TIME :
                      GREEN_TIME;

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
    end else begin
        // Handle counter
        if (pedestrian_override)
            cnt <= MIN_GREEN;
        else if (cnt == 1)
            cnt <= next_cnt;
        else
            cnt <= cnt - 1;

        // Handle state transitions
        if (to_red)        state <= RED;
        else if (to_yellow) state <= YELLOW;
        else if (to_green)  state <= GREEN;
    end
end

// Output assignments
assign clock = cnt;
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);

endmodule