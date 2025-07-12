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
reg [7:0] cnt_red, cnt_yellow, cnt_green;
reg [1:0] state;

// Initialize counters
parameter RED_TIMEOUT = 10;
parameter YELLOW_TIMEOUT = 5;
parameter GREEN_TIMEOUT = 60;

// State machine logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt_red <= RED_TIMEOUT;
        cnt_yellow <= 0;
        cnt_green <= 0;
    end else begin
        case (state)
            idle: begin
                state <= s1_red;
                cnt_red <= RED_TIMEOUT;
            end
            s1_red: begin
                if (cnt_red == 0) begin
                    state <= s3_green;
                    cnt_green <= GREEN_TIMEOUT;
                end else begin
                    cnt_red <= cnt_red - 1;
                end
            end
            s3_green: begin
                if (pass_request && cnt_green > 10) begin
                    cnt_green <= 10;
                end
                if (cnt_green == 0) begin
                    state <= s2_yellow;
                    cnt_yellow <= YELLOW_TIMEOUT;
                end else begin
                    cnt_green <= cnt_green - 1;
                end
            end
            s2_yellow: begin
                if (cnt_yellow == 0) begin
                    state <= s1_red;
                    cnt_red <= RED_TIMEOUT;
                end else begin
                    cnt_yellow <= cnt_yellow - 1;
                end
            end
            default: begin
                state <= idle;
            end
        endcase
    end
end

// Assign output signals
assign red = (state == s1_red);
assign yellow = (state == s2_yellow);
assign green = (state == s3_green);

// Assign clock output based on current state
always @(*) begin
    case (state)
        s1_red: clock = cnt_red;
        s3_green: clock = cnt_green;
        s2_yellow: clock = cnt_yellow;
        default: clock = 0;
    endcase
end

endmodule