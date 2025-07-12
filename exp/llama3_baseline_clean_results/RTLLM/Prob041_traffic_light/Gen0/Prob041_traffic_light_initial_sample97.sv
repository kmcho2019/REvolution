module traffic_light (
    input  logic rst_n,
    input  logic clk,
    input  logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Define the state enumeration
enum logic [1:0] {
    idle,
    s1_red,
    s2_yellow,
    s3_green
} state, next_state;

// Define the internal counter and previous state values
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// Always block for state transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        case (state)
            idle: next_state <= s1_red;
            s1_red: if (cnt == 0) next_state <= s3_green; else next_state <= s1_red;
            s2_yellow: if (cnt == 0) next_state <= s1_red; else next_state <= s2_yellow;
            s3_green: if (cnt == 0) next_state <= s2_yellow; else next_state <= s3_green;
            default: next_state <= idle;
        endcase
        state <= next_state;
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

// Always block for counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (pass_request && green && cnt > 10) begin
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

// Assign output signals based on the current state
assign red = (state == s1_red) ? 1'b1 : 1'b0;
assign yellow = (state == s2_yellow) ? 1'b1 : 1'b0;
assign green = (state == s3_green) ? 1'b1 : 1'b0;

// Assign the internal counter value to the output clock
assign clock = cnt;

endmodule