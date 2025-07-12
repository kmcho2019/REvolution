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
parameter RED_TIME    = 6'd10;
parameter YELLOW_TIME = 6'd5;
parameter GREEN_TIME  = 6'd60;
parameter MIN_GREEN   = 6'd10;

// State encoding
parameter s1_red    = 2'b00;
parameter s2_yellow = 2'b01;
parameter s3_green  = 2'b10;

reg [1:0] state, next_state;
reg [5:0] cnt;
wire cnt_load;
wire [5:0] cnt_next;

// State transition logic (combinatorial)
always @(*) begin
    next_state = state;
    
    case (state)
        s1_red:    if (cnt == 1) next_state = s3_green;
        s2_yellow: if (cnt == 1) next_state = s1_red;
        s3_green:  if (cnt == 1) next_state = s2_yellow;
        default:   next_state = s1_red;
    endcase
end

// Counter control logic
assign cnt_load = (state != next_state) || 
                 (pass_request && (state == s3_green) && (cnt > MIN_GREEN));

assign cnt_next = (state == s1_red)    ? RED_TIME :
                 (state == s2_yellow) ? YELLOW_TIME :
                 (state == s3_green)  ? (pass_request && cnt > MIN_GREEN) ? MIN_GREEN : GREEN_TIME :
                 RED_TIME;

// Sequential logic (state and counter updates)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= s1_red;
        cnt <= RED_TIME;
    end else begin
        state <= next_state;
        cnt <= cnt_load ? cnt_next : (cnt - 1);
    end
end

// Output assignments
assign red    = (state == s1_red);
assign yellow = (state == s2_yellow);
assign green  = (state == s3_green);
assign clock  = cnt;

endmodule