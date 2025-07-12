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
} state_type;

// Declare registers and wires
state_type state, next_state;
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// First always block: state transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        case (state)
            idle: next_state <= s1_red;
            s1_red: if (cnt == 0) next_state <= s3_green; else next_state <= s1_red;
            s2_yellow: if (cnt == 0) next_state <= s1_red; else next_state <= s2_yellow;
            s3_green: if (cnt == 0) next_state <= s2_yellow; else next_state <= s3_green;
            default: next_state <= idle;
        endcase
        state <= next_state;
        p_red <= (next_state == s1_red) ? 1 : 0;
        p_yellow <= (next_state == s2_yellow) ? 1 : 0;
        p_green <= (next_state == s3_green) ? 1 : 0;
    end
end

// Second always block: counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (pass_request && p_green) cnt <= 10;
        else if (!p_green && p_green) cnt <= 60;
        else if (!p_yellow && p_yellow) cnt <= 5;
        else if (!p_red && p_red) cnt <= 10;
        else cnt <= cnt - 1;
    end
end

// Assign statement: assign internal counter value to output clock
assign clock = cnt;

// Final always block: output signals
always @(posedge clk or negedge rst_n) begin
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

endmodule