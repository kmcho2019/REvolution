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
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Define registers for internal counter and previous signal values
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// Always block for state transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: if (cnt == 0) state <= s3_green; else state <= s1_red;
            s2_yellow: if (cnt == 0) state <= s1_red; else state <= s2_yellow;
            s3_green: if (cnt == 0) state <= s2_yellow; else state <= s3_green;
            default: state <= idle;
        endcase
    end
end

// Always block for counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (state == s1_red) begin
            if (cnt == 0) cnt <= 10; else cnt <= cnt - 1;
        end else if (state == s2_yellow) begin
            if (cnt == 0) cnt <= 5; else cnt <= cnt - 1;
        end else if (state == s3_green) begin
            if (pass_request && cnt > 10) cnt <= 10; 
            else if (cnt == 0) cnt <= 60; else cnt <= cnt - 1;
        end
    end
end

// Always block for output signal handling
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

// Assign internal counter to output clock
assign clock = cnt;

// Assign previous signal values to output signals
assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;

endmodule