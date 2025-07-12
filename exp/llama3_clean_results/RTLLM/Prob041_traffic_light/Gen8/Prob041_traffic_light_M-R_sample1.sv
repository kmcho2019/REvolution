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
parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

// Define the registers and wires
reg [7:0] cnt;
reg [1:0] state, next_state;
reg p_green;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 10;
        p_green <= 0;
    end else begin
        state <= next_state;
        if (pass_request && green) begin
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
        p_green <= green;
    end
end

// Next state logic
always @(*) begin
    case (state)
        idle: next_state = s1_red;
        s1_red: if (cnt == 0) next_state = s3_green; else next_state = s1_red;
        s2_yellow: if (cnt == 0) next_state = s1_red; else next_state = s2_yellow;
        s3_green: if (cnt == 0) next_state = s2_yellow; else next_state = s3_green;
        default: next_state = idle;
    endcase
end

// Output signal assignments
assign red = (state == s1_red);
assign yellow = (state == s2_yellow);
assign green = (state == s3_green);

// Assign the output clock
assign clock = cnt;

endmodule