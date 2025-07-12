module traffic_light(
    input  logic rst_n,
    input  logic clk,
    input  logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Define enumeration values for different states
enum logic [1:0] {
    idle,
    s1_red,
    s2_yellow,
    s3_green
} state, next_state;

// Define 1-bit registers for next values of red, yellow, and green signals
logic p_red, p_yellow, p_green;

// Define an 8-bit register for the internal counter
logic [7:0] cnt;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

// Counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else if (pass_request && green) begin
        cnt <= 10;
    end else if (!green && p_green) begin
        cnt <= 60;
    end else if (!yellow && p_yellow) begin
        cnt <= 5;
    end else if (!red && p_red) begin
        cnt <= 10;
    end else if (cnt > 0) begin
        cnt <= cnt - 1;
    end
end

// Output signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

// Assign previous values to output signals
assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;

// Assign value of internal counter to output clock
assign clock = cnt;

// Next state logic
always_comb begin
    case (state)
        idle: next_state = s1_red;
        s1_red: if (cnt == 0) next_state = s3_green; else next_state = s1_red;
        s2_yellow: if (cnt == 0) next_state = s1_red; else next_state = s2_yellow;
        s3_green: if (cnt == 0) next_state = s2_yellow; else next_state = s3_green;
        default: next_state = idle;
    endcase
end

// Output logic
always_comb begin
    case (state)
        idle: begin
            red = 0;
            yellow = 0;
            green = 0;
        end
        s1_red: begin
            red = 1;
            yellow = 0;
            green = 0;
        end
        s2_yellow: begin
            red = 0;
            yellow = 1;
            green = 0;
        end
        s3_green: begin
            red = 0;
            yellow = 0;
            green = 1;
        end
        default: begin
            red = 0;
            yellow = 0;
            green = 0;
        end
    endcase
end

endmodule