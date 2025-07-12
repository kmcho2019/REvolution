module traffic_light (
    input logic rst_n, // Reset signal (active low)
    input logic clk,  // Clock signal
    input logic pass_request, // Request signal for allowing vehicles to pass
    output logic [7:0] clock, // An 8-bit output representing the count value of the internal counter
    output logic red, yellow, green // Output signals representing the state of the traffic lights
);

// Define enumeration values for different states of the traffic light controller
enum logic [1:0] {
    idle = 2'b00,
    s1_red = 2'b01,
    s2_yellow = 2'b10,
    s3_green = 2'b11
} state, next_state;

// Internal registers
logic [7:0] cnt; // 8-bit register used as an internal counter for timing purposes
logic p_red, p_yellow, p_green; // 1-bit registers representing the next values for the red, yellow, and green signals

// First always block: State transition logic
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

// Second always block: Counting logic of the internal counter
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else if (pass_request && p_green) begin
        cnt <= 10;
    end else if (!p_green && p_green == 1'b1) begin
        cnt <= 60;
    end else if (!p_yellow && p_yellow == 1'b1) begin
        cnt <= 5;
    end else if (!p_red && p_red == 1'b1) begin
        cnt <= 10;
    end else if (cnt != 0) begin
        cnt <= cnt - 1;
    end
end

// Assign statement for output clock
assign clock = cnt;

// Third always block: Output signals
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        p_red <= (state == s1_red);
        p_yellow <= (state == s2_yellow);
        p_green <= (state == s3_green);
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

endmodule