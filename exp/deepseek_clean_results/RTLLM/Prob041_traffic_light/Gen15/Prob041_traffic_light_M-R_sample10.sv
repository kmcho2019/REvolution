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
parameter GREEN_TIME  = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME    = 10;
parameter MIN_GREEN   = 10;

// State encoding
reg [1:0] state, next_state;
reg [5:0] cnt;
wire      cnt_expired = (cnt == 1);

// State definitions
localparam RED    = 2'b00;
localparam YELLOW = 2'b01;
localparam GREEN  = 2'b10;

// Next state logic (combinational)
always @(*) begin
    case (state)
        RED:    next_state = GREEN;
        YELLOW: next_state = RED;
        GREEN:  next_state = YELLOW;
        default: next_state = RED;
    endcase
end

// State register (sequential)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
    end else if (cnt_expired) begin
        state <= next_state;
    end
end

// Pedestrian request handling
wire pedestrian_override = pass_request && (state == GREEN) && (cnt > MIN_GREEN);

// Counter logic (sequential)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else if (pedestrian_override) begin
        cnt <= MIN_GREEN;
    end else if (cnt_expired) begin
        case (next_state)
            RED:    cnt <= RED_TIME;
            YELLOW: cnt <= YELLOW_TIME;
            GREEN:  cnt <= GREEN_TIME;
            default: cnt <= RED_TIME;
        endcase
    end else begin
        cnt <= cnt - 1;
    end
end

// Output assignments
assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);
assign clock  = cnt;

endmodule