module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Define the states of the traffic light controller
parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

// Define the registers
reg [7:0] cnt;
reg [1:0] state;
reg [1:0] next_state;

// State machine logic
always @(*) begin
    case (state)
        idle: next_state = s1_red;
        s1_red: next_state = (cnt == 0) ? s3_green : s1_red;
        s3_green: next_state = (cnt == 0) ? s2_yellow : s3_green;
        s2_yellow: next_state = (cnt == 0) ? s1_red : s2_yellow;
        default: next_state = idle;
    endcase
end

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 10;
    end else begin
        state <= next_state;
        case (next_state)
            s1_red: cnt <= (cnt == 0) ? 10 : cnt - 1;
            s3_green: cnt <= (cnt == 0) ? 60 : (pass_request && cnt > 10) ? 10 : cnt - 1;
            s2_yellow: cnt <= (cnt == 0) ? 5 : cnt - 1;
            default: cnt <= cnt;
        endcase
    end
end

// Assign output signals
assign red = (state == s1_red);
assign yellow = (state == s2_yellow);
assign green = (state == s3_green);
assign clock = cnt;

endmodule