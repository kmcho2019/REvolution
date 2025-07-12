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
enum {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Define the registers for the traffic light signals
reg p_red, p_yellow, p_green;
reg [7:0] cnt;

// Always block for state transition logic
always @(*) begin
    case (state)
        idle: next_state = s1_red;
        s1_red: if (cnt == 0) next_state = s3_green; else next_state = s1_red;
        s2_yellow: if (cnt == 0) next_state = s1_red; else next_state = s2_yellow;
        s3_green: if (cnt == 0) next_state = s2_yellow; else next_state = s3_green;
        default: next_state = idle;
    endcase
end

// Always block for counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        state <= idle;
    end else begin
        case (state)
            idle: begin
                cnt <= 10;
                state <= s1_red;
            end
            s1_red: begin
                if (cnt > 0) cnt <= cnt - 1;
                if (cnt == 0) state <= s3_green;
            end
            s2_yellow: begin
                if (cnt > 0) cnt <= cnt - 1;
                if (cnt == 0) state <= s1_red;
            end
            s3_green: begin
                if (cnt > 0) cnt <= cnt - 1;
                if (cnt == 0) state <= s2_yellow;
                if (pass_request && cnt > 10) cnt <= 10;
            end
        endcase
    end
end

// Always block for output signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        case (state)
            s1_red: begin
                p_red <= 1;
                p_yellow <= 0;
                p_green <= 0;
            end
            s2_yellow: begin
                p_red <= 0;
                p_yellow <= 1;
                p_green <= 0;
            end
            s3_green: begin
                p_red <= 0;
                p_yellow <= 0;
                p_green <= 1;
            end
            default: begin
                p_red <= 0;
                p_yellow <= 0;
                p_green <= 0;
            end
        endcase
    end
end

// Assign the counter value to the output clock
assign clock = cnt;

// Assign the previous signal values to the output signals
assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;

endmodule