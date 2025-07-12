module traffic_light(
    input  logic        rst_n,
    input  logic        clk,
    input  logic        pass_request,
    output logic [7:0]  clock,
    output logic        red,
    output logic        yellow,
    output logic        green
);

// Define enumeration values for different states
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Define 8-bit register for internal counter
logic [7:0] cnt;

// Define 1-bit registers for previous values of output signals
logic p_red, p_yellow, p_green;

// First always block for state transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state
always_comb begin
    case (state)
        idle: next_state = s1_red;
        s1_red: next_state = (cnt == 0) ? s3_green : s1_red;
        s2_yellow: next_state = (cnt == 0) ? s1_red : s2_yellow;
        s3_green: next_state = (cnt == 0) ? s2_yellow : s3_green;
        default: next_state = idle;
    endcase
end

// Second always block for counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else if (pass_request && state == s3_green) begin
        cnt <= 10;
    end else if (state != s3_green && p_green) begin
        cnt <= 60;
    end else if (state != s2_yellow && p_yellow) begin
        cnt <= 5;
    end else if (state != s1_red && p_red) begin
        cnt <= 10;
    end else begin
        cnt <= cnt - 1;
    end
end

// Assign statement for output clock
assign clock = cnt;

// Third always block for output signals
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        p_red <= (state == s1_red);
        p_yellow <= (state == s2_yellow);
        p_green <= (state == s3_green);
    end
end

// Assign statement for output signals
assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;

endmodule