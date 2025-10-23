module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Define the states of the traffic light controller
parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

// Define the registers and wires
reg [7:0] cnt;
reg [1:0] state, next_state;
reg [7:0] red_cnt, yellow_cnt, green_cnt;

// Initialize counters
initial begin
    red_cnt = 8'd10;
    yellow_cnt = 8'd5;
    green_cnt = 8'd60;
end

// Control unit
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        state <= next_state;
        case (state)
            s1_red: begin
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
            s2_yellow: begin
                red <= 0;
                yellow <= 1;
                green <= 0;
            end
            s3_green: begin
                red <= 0;
                yellow <= 0;
                green <= 1;
            end
            default: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    case (state)
        idle: next_state = s1_red;
        s1_red: if (cnt == 0) next_state = s3_green; else next_state = s1_red;
        s2_yellow: if (cnt == 0) next_state = s1_red; else next_state = s2_yellow;
        s3_green: if (cnt == 0) next_state = s2_yellow; else next_state = s3_green;
        default: next_state = idle;
    endcase
end

// Timing unit
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd0;
    end else begin
        case (state)
            s1_red: begin
                if (cnt < red_cnt) begin
                    cnt <= cnt + 1;
                end else begin
                    cnt <= 8'd0;
                end
            end
            s2_yellow: begin
                if (cnt < yellow_cnt) begin
                    cnt <= cnt + 1;
                end else begin
                    cnt <= 8'd0;
                end
            end
            s3_green: begin
                if (pass_request && cnt < green_cnt) begin
                    if (green_cnt - cnt > 10) begin
                        cnt <= green_cnt - 10;
                    end
                end else if (cnt < green_cnt) begin
                    cnt <= cnt + 1;
                end else begin
                    cnt <= 8'd0;
                end
            end
            default: begin
                cnt <= 8'd0;
            end
        endcase
    end
end

// Assign the output clock
assign clock = cnt;

endmodule