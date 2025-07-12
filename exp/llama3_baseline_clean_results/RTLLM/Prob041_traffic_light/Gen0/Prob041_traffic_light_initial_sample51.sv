module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Define the states
enum logic [1:0] {
    idle,
    s1_red,
    s2_yellow,
    s3_green
} state, next_state;

// Internal counter
logic [7:0] cnt;

// Previous signal values
logic p_red, p_yellow, p_green;

// Next signal values
logic n_red, n_yellow, n_green;

// State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        state <= next_state;
        p_red <= n_red;
        p_yellow <= n_yellow;
        p_green <= n_green;
    end
end

always_comb begin
    case (state)
        idle: begin
            next_state = s1_red;
            n_red = 1;
            n_yellow = 0;
            n_green = 0;
        end
        s1_red: begin
            if (cnt == 0) begin
                next_state = s3_green;
            end else begin
                next_state = s1_red;
            end
            n_red = 1;
            n_yellow = 0;
            n_green = 0;
        end
        s2_yellow: begin
            if (cnt == 0) begin
                next_state = s1_red;
            end else begin
                next_state = s2_yellow;
            end
            n_red = 0;
            n_yellow = 1;
            n_green = 0;
        end
        s3_green: begin
            if (cnt == 0) begin
                next_state = s2_yellow;
            end else if (pass_request && p_green && cnt > 10) begin
                next_state = s3_green;
            end else begin
                next_state = s3_green;
            end
            n_red = 0;
            n_yellow = 0;
            n_green = 1;
        end
        default: begin
            next_state = idle;
            n_red = 0;
            n_yellow = 0;
            n_green = 0;
        end
    endcase
end

// Counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (p_green && pass_request && cnt > 10) begin
            cnt <= 10;
        end else if (!p_green && p_green != n_green) begin
            cnt <= 60;
        end else if (!p_yellow && p_yellow != n_yellow) begin
            cnt <= 5;
        end else if (!p_red && p_red != n_red) begin
            cnt <= 10;
        end else if (cnt != 0) begin
            cnt <= cnt - 1;
        end
    end
end

// Output signals
assign clock = cnt;
assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;

endmodule