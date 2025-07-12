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
enum logic [1:0] {
    idle,
    s1_red,
    s2_yellow,
    s3_green
} state, next_state;

// Internal counter
logic [7:0] cnt;

// Previous output values
logic p_red, p_yellow, p_green;

// Next output values
logic n_red, n_yellow, n_green;

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
        cnt <= 10;
    end else if (pass_request && p_green) begin
        cnt <= 10;
    end else if (!p_green && p_green == 1'b1) begin
        cnt <= 60;
    end else if (!p_yellow && p_yellow == 1'b1) begin
        cnt <= 5;
    end else if (!p_red && p_red == 1'b1) begin
        cnt <= 10;
    end else if (cnt > 0) begin
        cnt <= cnt - 1;
    end
end

// Output signal updates
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        p_red <= n_red;
        p_yellow <= n_yellow;
        p_green <= n_green;
    end
end

always_comb begin
    case (state)
        idle: begin
            n_red = 0;
            n_yellow = 0;
            n_green = 0;
        end
        s1_red: begin
            n_red = 1;
            n_yellow = 0;
            n_green = 0;
        end
        s2_yellow: begin
            n_red = 0;
            n_yellow = 1;
            n_green = 0;
        end
        s3_green: begin
            n_red = 0;
            n_yellow = 0;
            n_green = 1;
        end
        default: begin
            n_red = 0;
            n_yellow = 0;
            n_green = 0;
        end
    endcase
end

assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;
assign clock = cnt;

endmodule