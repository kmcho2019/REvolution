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
parameter [5:0] GREEN_TIME  = 60;
parameter [5:0] YELLOW_TIME = 5;
parameter [5:0] RED_TIME    = 10;
parameter [5:0] MIN_GREEN   = 10;

// One-hot state encoding
reg [2:0] state;
reg [5:0] cnt;
wire [2:0] next_state;
wire [5:0] next_cnt;

// State definitions
localparam RED    = 3'b001;
localparam YELLOW = 3'b010;
localparam GREEN  = 3'b100;

// Next state logic
assign next_state = (!rst_n) ? RED :
                   (cnt == 0) ? 
                   (state == RED)    ? GREEN :
                    state == YELLOW ? RED :
                    state == GREEN  ? YELLOW : state) : state;

// Pedestrian request handling
wire pedestrian_request = (state == GREEN) && pass_request && (cnt > MIN_GREEN);

// Next counter logic
assign next_cnt = (!rst_n) ? RED_TIME :
                 pedestrian_request ? MIN_GREEN :
                 (cnt == 0) ? 
                 (next_state == RED)    ? RED_TIME :
                 next_state == YELLOW ? YELLOW_TIME :
                 next_state == GREEN  ? GREEN_TIME : cnt :
                 cnt - 1;

// Register updates
always @(posedge clk) begin
    state <= next_state;
    cnt <= next_cnt;
end

// Output assignments
assign red    = state[0];  // RED is 001
assign yellow = state[1];  // YELLOW is 010
assign green  = state[2];  // GREEN is 100
assign clock  = cnt;

endmodule