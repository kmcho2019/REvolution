module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output red,
    output yellow,
    output green
);

parameter RED_TIME = 10;
parameter YELLOW_TIME = 5;
parameter GREEN_TIME = 60;
parameter MIN_GREEN = 10;

reg [5:0] cnt;
reg [2:0] state;  // One-hot: state[0]=RED, state[1]=YELLOW, state[2]=GREEN

// Next state logic
wire next_red = (state[1] && cnt == 0) || (state[2] && cnt == 0);
wire next_yellow = state[2] && cnt == 0;
wire next_green = state[0] && cnt == 0;

// Counter load values
wire [5:0] next_cnt = 
    (!rst_n) ? RED_TIME :
    (next_red) ? RED_TIME :
    (next_yellow) ? YELLOW_TIME :
    (next_green) ? GREEN_TIME :
    (pass_request && state[2] && cnt > MIN_GREEN) ? MIN_GREEN :
    cnt - 1;

// State transitions
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 3'b001;  // RED
        cnt <= RED_TIME;
    end else begin
        cnt <= next_cnt;
        if (cnt == 0) begin
            case (1'b1)
                state[0]: state <= 3'b100;  // RED->GREEN
                state[1]: state <= 3'b001;  // YELLOW->RED
                state[2]: state <= 3'b010;  // GREEN->YELLOW
            endcase
        end
    end
end

// Output assignments
assign red = state[0];
assign yellow = state[1];
assign green = state[2];
assign clock = cnt;

endmodule