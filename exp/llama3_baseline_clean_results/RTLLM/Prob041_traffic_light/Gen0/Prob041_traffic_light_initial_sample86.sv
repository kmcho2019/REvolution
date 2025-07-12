module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Define enumeration values for different states
typedef enum logic [1:0] {
    idle,
    s1_red,
    s2_yellow,
    s3_green
} state_t;

// Define registers and wires
state_t state, next_state;
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: if (cnt == 0) state <= s3_green; else state <= s1_red;
            s2_yellow: if (cnt == 0) state <= s1_red; else state <= s2_yellow;
            s3_green: if (cnt == 0) state <= s2_yellow; else state <= s3_green;
            default: state <= idle;
        endcase
        p_red <= (state == s1_red);
        p_yellow <= (state == s2_yellow);
        p_green <= (state == s3_green);
    end
end

// Counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (state == s1_red) begin
            if (cnt == 0) cnt <= 10;
            else cnt <= cnt - 1;
        end else if (state == s2_yellow) begin
            if (cnt == 0) cnt <= 5;
            else cnt <= cnt - 1;
        end else if (state == s3_green) begin
            if (pass_request && cnt > 10) cnt <= 10;
            else if (cnt == 0) cnt <= 60;
            else cnt <= cnt - 1;
        end
    end
end

// Output signals
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

// Assign statement
assign clock = cnt;

endmodule