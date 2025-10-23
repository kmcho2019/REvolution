module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Define states
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Internal counter
logic [7:0] cnt;

// Next values for output signals
logic p_red, p_yellow, p_green;

// State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        idle: next_state = s1_red;
        s1_red: next_state = (cnt == 0) ? s3_green : s1_red;
        s2_yellow: next_state = (cnt == 0) ? s1_red : s2_yellow;
        s3_green: next_state = (cnt == 0) ? s2_yellow : s3_green;
        default: next_state = idle;
    endcase
end

// Counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10;
    end else begin
        if (pass_request && green && cnt > 8'd10) begin
            cnt <= 8'd10;
        end else if (!green && p_green) begin
            cnt <= 8'd60;
        end else if (!yellow && p_yellow) begin
            cnt <= 8'd5;
        end else if (!red && p_red) begin
            cnt <= 8'd10;
        end else begin
            if (cnt != 0) begin
                cnt <= cnt - 1;
            end
        end
    end
end

// Output signal logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        p_red <= (state == s1_red) ? 1'b1 : (state == s2_yellow || state == s3_green) ? 1'b0 : p_red;
        p_yellow <= (state == s2_yellow) ? 1'b1 : (state == s1_red || state == s3_green) ? 1'b0 : p_yellow;
        p_green <= (state == s3_green) ? 1'b1 : (state == s1_red || state == s2_yellow) ? 1'b0 : p_green;
    end
end

// Assign output signals
assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;

// Assign clock output
assign clock = cnt;

endmodule