module traffic_light(
    input  logic rst_n,
    input  logic clk,
    input  logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Define enumeration values for different states
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Define 1-bit registers for the next values of the red, yellow, and green signals
logic p_red, p_yellow, p_green;

// Define an 8-bit register for the internal counter
logic [7:0] cnt;

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

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (pass_request && green) begin
            cnt <= 10;
        end else if (!green && p_green) begin
            cnt <= 60;
        end else if (!yellow && p_yellow) begin
            cnt <= 5;
        end else if (!red && p_red) begin
            cnt <= 10;
        end else begin
            cnt <= cnt - 1;
        end
    end
end

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        p_red <= (state == s1_red) ? 1 : 0;
        p_yellow <= (state == s2_yellow) ? 1 : 0;
        p_green <= (state == s3_green) ? 1 : 0;
    end
end

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

assign clock = cnt;

endmodule