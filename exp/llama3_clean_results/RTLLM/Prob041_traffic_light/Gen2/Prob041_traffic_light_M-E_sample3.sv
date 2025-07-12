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

// Define the sub-states for each state
parameter red_count = 2'b00, yellow_count = 2'b01, green_count = 2'b10, green_request = 2'b11;

// Define the registers
reg [1:0] state;
reg [1:0] sub_state;
reg [7:0] cnt;

// Main state machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        sub_state <= red_count;
        cnt <= 10;
    end else begin
        case (state)
            idle: begin
                state <= s1_red;
                sub_state <= red_count;
                cnt <= 10;
            end
            s1_red: begin
                if (sub_state == red_count && cnt == 0) begin
                    state <= s3_green;
                    sub_state <= green_count;
                    cnt <= 60;
                end
            end
            s3_green: begin
                if (sub_state == green_count && cnt == 0) begin
                    state <= s2_yellow;
                    sub_state <= yellow_count;
                    cnt <= 5;
                end else if (sub_state == green_request && cnt == 0) begin
                    state <= s2_yellow;
                    sub_state <= yellow_count;
                    cnt <= 5;
                end
            end
            s2_yellow: begin
                if (sub_state == yellow_count && cnt == 0) begin
                    state <= s1_red;
                    sub_state <= red_count;
                    cnt <= 10;
                end
            end
            default: begin
                state <= state;
                sub_state <= sub_state;
            end
        endcase
    end
end

// Sub-state machine for red state
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sub_state <= red_count;
    end else if (state == s1_red) begin
        if (cnt > 0) begin
            sub_state <= red_count;
        end else begin
            sub_state <= green_count;
        end
    end
end

// Sub-state machine for green state
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sub_state <= green_count;
    end else if (state == s3_green) begin
        if (cnt > 0 && !pass_request) begin
            sub_state <= green_count;
        end else if (cnt > 0 && pass_request) begin
            sub_state <= green_request;
        end else if (cnt == 0) begin
            sub_state <= yellow_count;
        end
    end
end

// Sub-state machine for yellow state
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sub_state <= yellow_count;
    end else if (state == s2_yellow) begin
        if (cnt > 0) begin
            sub_state <= yellow_count;
        end else begin
            sub_state <= red_count;
        end
    end
end

// Counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        case (state)
            s1_red: begin
                if (sub_state == red_count) begin
                    cnt <= cnt - 1;
                end
            end
            s3_green: begin
                if (sub_state == green_count) begin
                    cnt <= cnt - 1;
                end else if (sub_state == green_request) begin
                    cnt <= 10;
                end
            end
            s2_yellow: begin
                if (sub_state == yellow_count) begin
                    cnt <= cnt - 1;
                end
            end
            default: begin
                cnt <= cnt;
            end
        endcase
    end
end

// Pedestrian request logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else if (pass_request && state == s3_green && sub_state == green_count && cnt > 10) begin
        cnt <= 10;
    end
end

// Output signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
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

// Assign the value of the internal counter to the output clock
assign clock = cnt;

endmodule