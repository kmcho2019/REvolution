module traffic_light (
    input  logic         rst_n,  // Reset signal (active low)
    input  logic         clk,   // Clock signal
    input  logic         pass_request,  // Request signal for allowing vehicles to pass
    output logic [7:0]    clock,  // An 8-bit output representing the count value of the internal counter
    output logic         red,   // Output signal representing the red state of the traffic light
    output logic         yellow,  // Output signal representing the yellow state of the traffic light
    output logic         green  // Output signal representing the green state of the traffic light
);

// Enumerations for different states of the traffic light controller
enum logic [1:0] {
    idle = 2'b00,
    s1_red = 2'b01,
    s2_yellow = 2'b10,
    s3_green = 2'b11
} state, next_state;

// Internal counter
logic [7:0] cnt;

// Registers for next values of the output signals
logic p_red, p_yellow, p_green;

// State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

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
    end else if (pass_request && p_green) begin
        cnt <= 10;
    end else if (!p_green && p_green != green) begin
        cnt <= 60;
    end else if (!p_yellow && p_yellow != yellow) begin
        cnt <= 5;
    end else if (!p_red && p_red != red) begin
        cnt <= 10;
    end else begin
        cnt <= cnt - 1;
    end
end

// Output signals
always_ff @(posedge clk or negedge rst_n) begin
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

// Assign output signals based on the current state
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

// Assign internal counter value to output clock signal
assign clock = cnt;

endmodule