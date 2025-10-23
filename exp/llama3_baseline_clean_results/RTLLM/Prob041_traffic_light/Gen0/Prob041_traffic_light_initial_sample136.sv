module traffic_light(
    input   logic               rst_n,      // Reset signal (active low)
    input   logic               clk,       // Clock signal
    input   logic               pass_request, // Request signal for allowing vehicles to pass
    output  logic [7:0]         clock,     // An 8-bit output representing the count value of the internal counter
    output  logic               red,       // Output signal representing the state of the red traffic light
    output  logic               yellow,    // Output signal representing the state of the yellow traffic light
    output  logic               green      // Output signal representing the state of the green traffic light
);

// Define the enumeration values for different states of the traffic light controller
localparam idle = 2'b00;
localparam s1_red = 2'b01;
localparam s2_yellow = 2'b10;
localparam s3_green = 2'b11;

// Define the registers and wires
logic [1:0] state, next_state;
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// The first always block is responsible for the state transition logic
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

// The second always block handles the counting logic of the internal counter
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
    end else if (cnt > 0) begin
        cnt <= cnt - 1;
    end else begin
        cnt <= cnt;
    end
end

// The assign statement assigns the value of the internal counter to the output clock
assign clock = cnt;

// The final always block handles the output signals
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        p_red <= (state == s1_red) ? 1'b1 : 0;
        p_yellow <= (state == s2_yellow) ? 1'b1 : 0;
        p_green <= (state == s3_green) ? 1'b1 : 0;
    end
end

always_comb begin
    red = p_red;
    yellow = p_yellow;
    green = p_green;
end

endmodule