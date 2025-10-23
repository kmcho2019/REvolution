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
        p_red <= 1;
        p_yellow <= 0;
        p_green <= 0;
    end else if (pass_request && p_green) begin
        cnt <= (cnt > 10) ? 10 : cnt;
    end else if (!p_green && (state == s3_green || state == s2_yellow)) begin
        cnt <= (state == s3_green) ? 60 : 5;
    end else if (!p_red && (state == s1_red)) begin
        cnt <= 10;
    end else if (!p_yellow && (state == s2_yellow)) begin
        cnt <= 5;
    end else begin
        cnt <= cnt - 1;
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

// Assign internal counter to output clock
assign clock = cnt;

// Update state and output signals
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
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

endmodule