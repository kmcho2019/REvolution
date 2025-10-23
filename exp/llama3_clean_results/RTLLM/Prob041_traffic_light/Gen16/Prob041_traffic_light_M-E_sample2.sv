module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Define the states of the traffic light controller
parameter idle = 3'b001, s1_red = 3'b010, s2_yellow = 3'b100, s3_green = 3'b011;

// Define the registers and wires
reg [7:0] cnt;
reg [2:0] state, next_state;
reg p_green;

// Counter module
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else if (pass_request && p_green) begin
        cnt <= 10;
    end else if (cnt == 0) begin
        case (state)
            s1_red: cnt <= 60;
            s2_yellow: cnt <= 10;
            s3_green: cnt <= 5;
            default: cnt <= 10;
        endcase
    end else if (cnt > 0) begin
        cnt <= cnt - 1;
    end
end

// State machine module
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_green <= 0;
    end else begin
        state <= next_state;
        p_green <= (state == s3_green);
    end
end

always @(*) begin
    case (state)
        idle: next_state = s1_red;
        s1_red: if (cnt == 0) next_state = s3_green; else next_state = s1_red;
        s2_yellow: if (cnt == 0) next_state = s1_red; else next_state = s2_yellow;
        s3_green: if (cnt == 0) next_state = s2_yellow; else next_state = s3_green;
        default: next_state = idle;
    endcase
end

// Output signal generation module
always @(*) begin
    case (state)
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

// Assign the output clock
assign clock = cnt;

endmodule