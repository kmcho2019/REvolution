module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding
parameter idle = 2'd0,
          s1_red = 2'd1,
          s2_yellow = 2'd2,
          s3_green = 2'd3;

reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: if (cnt == 0) state <= s3_green;
                     else state <= s1_red;
            s2_yellow: if (cnt == 0) state <= s1_red;
                       else state <= s2_yellow;
            s3_green: if (cnt == 0) state <= s2_yellow;
                      else state <= s3_green;
            default: state <= idle;
        endcase
    end
end

// Output logic for next output signals based on state
wire next_red = (state == s1_red);
wire next_yellow = (state == s2_yellow);
wire next_green = (state == s3_green);

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10; // initial count for red state length
    end else begin
        // Handle pedestrian pass_request shortening green time
        if (pass_request && green && cnt > 10) begin
            cnt <= 10;
        end else if (!green && p_green) begin
            // Transition from green to yellow: reset to yellow time 5
            cnt <= 5;
        end else if (!yellow && p_yellow) begin
            // Transition from yellow to red: reset to red time 10
            cnt <= 10;
        end else if (!red && p_red) begin
            // Transition from red to green: reset to green time 60
            cnt <= 60;
        end else if (cnt > 0) begin
            cnt <= cnt - 1;
        end
    end
end

// Output registers update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        p_red <= next_red;
        p_yellow <= next_yellow;
        p_green <= next_green;
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

assign clock = cnt;

endmodule