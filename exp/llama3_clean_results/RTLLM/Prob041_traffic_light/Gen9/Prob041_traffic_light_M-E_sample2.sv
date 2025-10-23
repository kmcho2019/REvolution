module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Define the states of the traffic light controller
parameter idle = 2'b00, red_state = 2'b01, yellow_state = 2'b10, green_state = 2'b11;

// Define the registers
reg [7:0] cnt;
reg [1:0] state;
reg [1:0] next_state;
reg clk_gate;

// Clock gating logic
always @(*) begin
    if (state == idle || cnt == 0) begin
        clk_gate = 0;
    end else begin
        clk_gate = 1;
    end
end

// State machine logic
always @(*) begin
    case (state)
        idle: next_state = red_state;
        red_state: next_state = (cnt == 60) ? green_state : red_state;
        green_state: next_state = (cnt == 0) ? yellow_state : green_state;
        yellow_state: next_state = (cnt == 5) ? red_state : yellow_state;
        default: next_state = idle;
    endcase
end

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 10;
    end else if (clk_gate) begin
        state <= next_state;
        case (next_state)
            red_state: cnt <= (cnt == 0) ? 60 : cnt + 1;
            green_state: cnt <= (cnt == 0) ? 60 : (pass_request && cnt > 10) ? 10 : cnt + 1;
            yellow_state: cnt <= (cnt == 0) ? 5 : cnt + 1;
            default: cnt <= cnt;
        endcase
    end
end

// Assign output signals
assign red = (state == red_state);
assign yellow = (state == yellow_state);
assign green = (state == green_state && cnt > 0);
assign clock = cnt;

endmodule