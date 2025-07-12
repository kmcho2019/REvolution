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

// One-hot state encoding
localparam RED    = 3'b100;
localparam YELLOW = 3'b010;
localparam GREEN  = 3'b001;

reg [2:0] current_state;
reg [5:0] cnt;

// Next state logic (combinational)
wire next_red    = (current_state == GREEN && cnt == 1) || 
                  (current_state == YELLOW && cnt == 1);
wire next_yellow = (current_state == RED && cnt == 1);
wire next_green  = (current_state == YELLOW && cnt == 1);

// State transition (sequential)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= RED;
    end else begin
        case (1'b1)
            next_red:    current_state <= RED;
            next_yellow: current_state <= YELLOW;
            next_green:  current_state <= GREEN;
            default:     current_state <= current_state;
        endcase
    end
end

// Pedestrian request handling
wire handle_request = pass_request && (current_state == GREEN) && (cnt > MIN_GREEN);

// Counter logic (sequential)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else if (handle_request) begin
        cnt <= MIN_GREEN;
    end else if (cnt == 1) begin
        case (1'b1)
            next_red:    cnt <= RED_TIME;
            next_yellow: cnt <= YELLOW_TIME;
            next_green:  cnt <= GREEN_TIME;
            default:     cnt <= cnt;
        endcase
    end else begin
        cnt <= cnt - 1;
    end
end

// Output assignments
assign clock = cnt;
assign red    = current_state[2];
assign yellow = current_state[1];
assign green  = current_state[0];

endmodule