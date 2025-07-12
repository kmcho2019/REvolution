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
reg [1:0] state, next_state;
reg [5:0] cnt;

// State definitions
localparam RED    = 2'b00;
localparam YELLOW = 2'b01;
localparam GREEN  = 2'b10;

// Next state and counter load value logic
wire [5:0] next_cnt;
wire cnt_load;

assign cnt_load = (cnt == 1) || (!rst_n) || 
                 (pass_request && (state == GREEN) && (cnt > MIN_GREEN));

assign next_cnt = (!rst_n) ? RED_TIME :
                 (pass_request && (state == GREEN) && (cnt > MIN_GREEN)) ? MIN_GREEN :
                 (state == RED && cnt == 1) ? GREEN_TIME :
                 (state == YELLOW && cnt == 1) ? RED_TIME :
                 (state == GREEN && cnt == 1) ? YELLOW_TIME :
                 cnt - 1;

assign next_state = (!rst_n) ? RED :
                   (state == RED && cnt == 1) ? GREEN :
                   (state == YELLOW && cnt == 1) ? RED :
                   (state == GREEN && cnt == 1) ? YELLOW :
                   state;

// Counter register
always @(posedge clk) begin
    cnt <= next_cnt;
end

// State register
always @(posedge clk) begin
    state <= next_state;
end

// Output assignments
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);
assign clock = cnt;

endmodule