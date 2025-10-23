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
localparam [1:0] RED_ST    = 2'b00;
localparam [1:0] YELLOW_ST = 2'b01;
localparam [1:0] GREEN_ST  = 2'b10;

reg [1:0] state;
reg [7:0] cnt;
wire [7:0] next_cnt;

// Continuous counter with dynamic thresholds
assign next_cnt = (!rst_n) ? RED_TIME :
                 (state == GREEN_ST && pass_request && cnt > MIN_GREEN) ? MIN_GREEN :
                 (cnt == 1) ? 
                     (state == RED_ST) ? GREEN_TIME :
                     (state == YELLOW_ST) ? RED_TIME :
                     YELLOW_TIME : // GREEN_ST case
                 cnt - 1;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED_ST;
        cnt <= RED_TIME;
    end else begin
        cnt <= next_cnt;
        
        // State transitions occur when counter reaches 1
        if (cnt == 1) begin
            case (state)
                RED_ST:    state <= GREEN_ST;
                YELLOW_ST: state <= RED_ST;
                GREEN_ST:  state <= YELLOW_ST;
            endcase
        end
    end
end

// Output logic - combinatorial
always @(*) begin
    red = 1'b0;
    yellow = 1'b0;
    green = 1'b0;
    
    case (state)
        RED_ST:    red = 1'b1;
        YELLOW_ST: yellow = 1'b1;
        GREEN_ST:  green = 1'b1;
    endcase
end

assign clock = cnt;

endmodule