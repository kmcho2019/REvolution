module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Define the states of the finite state machine
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Define the registers for the internal counter and the output signals
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// State transition logic
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
    end else if (pass_request && p_green && p_green == 1'b1) begin
        cnt <= (cnt > 10) ? 10 : cnt;
    end else if (!p_green && p_green == 1'b0) begin
        cnt <= 60;
    end else if (!p_yellow && p_yellow == 1'b0) begin
        cnt <= 5;
    end else if (!p_red && p_red == 1'b0) begin
        cnt <= 10;
    end else begin
        cnt <= cnt - 1;
    end
end

// Output signal assignment
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
        state <= idle;
    end else begin
        state <= next_state;
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

// Assign the output signals
assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;
assign clock = cnt;

endmodule