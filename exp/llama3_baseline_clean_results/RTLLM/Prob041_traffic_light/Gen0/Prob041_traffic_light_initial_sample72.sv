module traffic_light(
    input  logic          rst_n,  // Reset signal (active low)
    input  logic          clk,     // Clock signal
    input  logic          pass_request,  // Request signal for allowing vehicles to pass
    output logic [7:0]    clock,   // An 8-bit output representing the count value of the internal counter
    output logic          red,     // Output signal representing the red light
    output logic          yellow,  // Output signal representing the yellow light
    output logic          green    // Output signal representing the green light
);

// Enumerations for the states of the traffic light controller
enum logic [1:0] { idle, s1_red, s2_yellow, s3_green } state, next_state;

// Registers for the internal counter and the current state
logic [7:0] cnt;
logic [1:0] p_state;

// Registers for the next values of the output signals
logic p_red, p_yellow, p_green;

// First always block: State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_state <= idle;
    end else begin
        state <= next_state;
        p_state <= state;
    end
end

always_comb begin
    case (state)
        idle: next_state = s1_red;
        s1_red: next_state = (cnt == 0)? s3_green : s1_red;
        s2_yellow: next_state = (cnt == 0)? s1_red : s2_yellow;
        s3_green: next_state = (cnt == 0)? s2_yellow : s3_green;
        default: next_state = idle;
    endcase
end

// Second always block: Counting logic of the internal counter
always_ff @(posedge clk or negedge rst_n) begin
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

// Assign statement: Assign the value of the internal counter to the output clock
assign clock = cnt;

// Final always block: Output signals
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        p_red <= (state == s1_red)? 1 : 0;
        p_yellow <= (state == s2_yellow)? 1 : 0;
        p_green <= (state == s3_green)? 1 : 0;
    end
end

always_comb begin
    case (state)
        idle: begin red = 0; yellow = 0; green = 0; end
        s1_red: begin red = 1; yellow = 0; green = 0; end
        s2_yellow: begin red = 0; yellow = 1; green = 0; end
        s3_green: begin red = 0; yellow = 0; green = 1; end
        default: begin red = 0; yellow = 0; green = 0; end
    endcase
end

endmodule