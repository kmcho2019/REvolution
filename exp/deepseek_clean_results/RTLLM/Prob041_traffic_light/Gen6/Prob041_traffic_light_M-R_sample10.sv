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
parameter GREEN_TIME = 6'd60;
parameter YELLOW_TIME = 6'd5;
parameter RED_TIME = 6'd10;
parameter PEDESTRIAN_MIN_GREEN = 6'd10;

// State encoding
parameter s1_red    = 2'b00;
parameter s2_yellow = 2'b01;
parameter s3_green  = 2'b10;

reg [1:0] state, next_state;
reg [5:0] cnt;
wire cnt_expired = (cnt == 6'd1);
wire pedestrian_shorten = pass_request && (state == s3_green) && (cnt > PEDESTRIAN_MIN_GREEN);

// Combinational next state logic
always @(*) begin
    case (state)
        s1_red:    next_state = cnt_expired ? s3_green : s1_red;
        s2_yellow: next_state = cnt_expired ? s1_red : s2_yellow;
        s3_green:  next_state = cnt_expired ? s2_yellow : s3_green;
        default:   next_state = s1_red;
    endcase
end

// Sequential state and counter update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= s1_red;
        cnt <= RED_TIME;
    end else begin
        state <= next_state;
        
        if (pedestrian_shorten) begin
            cnt <= PEDESTRIAN_MIN_GREEN;
        end else if (cnt_expired) begin
            case (next_state)
                s1_red:    cnt <= RED_TIME;
                s2_yellow: cnt <= YELLOW_TIME;
                s3_green:  cnt <= GREEN_TIME;
                default:  cnt <= RED_TIME;
            endcase
        end else begin
            cnt <= cnt - 1;
        end
    end
end

// Output assignments
assign red = (state == s1_red);
assign yellow = (state == s2_yellow);
assign green = (state == s3_green);
assign clock = cnt;

endmodule