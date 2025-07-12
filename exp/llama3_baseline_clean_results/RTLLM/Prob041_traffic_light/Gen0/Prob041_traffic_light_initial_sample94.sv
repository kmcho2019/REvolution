module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Define the enumeration values for the states
enum logic [1:0] {
    idle,
    s1_red,
    s2_yellow,
    s3_green
} state, next_state;

// Define the registers for the next values of the output signals
logic p_red, p_yellow, p_green;

// Define the internal counter
logic [7:0] cnt;

// First always block for state transition logic
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
        // Handle the pedestrian button press
        if (pass_request && p_green) begin
            if (cnt > 10) cnt <= 10;
        end
    end
end

// Second always block for counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        case (state)
            s1_red: if (p_red) cnt <= 10; else cnt <= cnt - 1;
            s2_yellow: if (p_yellow) cnt <= 5; else cnt <= cnt - 1;
            s3_green: if (p_green) cnt <= 60; else cnt <= cnt - 1;
            default: cnt <= cnt - 1;
        endcase
    end
end

// Assign statement for output clock
assign clock = cnt;

// Final always block for output signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        case (state)
            idle: red <= 0; yellow <= 0; green <= 0;
            s1_red: red <= 1; yellow <= 0; green <= 0;
            s2_yellow: red <= 0; yellow <= 1; green <= 0;
            s3_green: red <= 0; yellow <= 0; green <= 1;
            default: red <= 0; yellow <= 0; green <= 0;
        endcase
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

endmodule