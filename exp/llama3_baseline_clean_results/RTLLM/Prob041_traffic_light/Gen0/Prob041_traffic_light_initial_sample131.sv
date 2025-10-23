module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red, yellow, green
);

// Define the states of the traffic light controller
typedef enum logic [1:0] {
    idle,
    s1_red,
    s2_yellow,
    s3_green
} state_type;

// Define the registers for the state and the internal counter
state_type state, next_state;
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// Always block for the state transition logic
always_comb begin
    case (state)
        idle: next_state = s1_red;
        s1_red: begin
            if (cnt == 0) next_state = s3_green;
            else next_state = s1_red;
        end
        s2_yellow: begin
            if (cnt == 0) next_state = s1_red;
            else next_state = s2_yellow;
        end
        s3_green: begin
            if (cnt == 0) next_state = s2_yellow;
            else if (pass_request && cnt > 10) next_state = s3_green;
            else next_state = s3_green;
        end
    endcase
end

// Always block for the counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
        state <= idle;
    end else begin
        case (state)
            idle: begin
                cnt <= 10;
                state <= next_state;
            end
            s1_red: begin
                if (cnt == 0) state <= next_state;
                cnt <= cnt - 1;
            end
            s2_yellow: begin
                if (cnt == 0) state <= next_state;
                cnt <= cnt - 1;
            end
            s3_green: begin
                if (pass_request && cnt > 10) cnt <= 10;
                else if (cnt == 0) state <= next_state;
                cnt <= cnt - 1;
            end
        endcase
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

// Always block for the output signals
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        red <= (state == s1_red) ? 1 : (p_red && state != s1_red) ? 0 : red;
        yellow <= (state == s2_yellow) ? 1 : (p_yellow && state != s2_yellow) ? 0 : yellow;
        green <= (state == s3_green) ? 1 : (p_green && state != s3_green) ? 0 : green;
    end
end

// Assign the value of the internal counter to the output clock
assign clock = cnt;

endmodule