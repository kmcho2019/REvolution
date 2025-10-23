module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,  // Reduced from 8 to 6 bits
    output reg red,
    output reg yellow,
    output reg green
);

// Parameters
parameter G_T = 60;  // Green time
parameter Y_T = 5;   // Yellow time
parameter R_T = 10;  // Red time
parameter MIN_G = 10; // Minimum green time

// One-hot encoded states
parameter IDLE = 4'b0001;
parameter RED = 4'b0010;
parameter YELLOW = 4'b0100;
parameter GREEN = 4'b1000;
reg [3:0] state;

// Counter (reduced to 6 bits)
reg [5:0] cnt;
wire counter_enable = (state != IDLE) && (cnt != 0);

// State transition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        case (1'b1)  // Synthesis will recognize this as priority encoder
            state[0]: state <= RED;
            state[1]: cnt == 1 ? state <= GREEN : state <= RED;
            state[2]: cnt == 1 ? state <= RED : state <= YELLOW;
            state[3]: cnt == 1 ? state <= YELLOW : state <= GREEN;
            default: state <= IDLE;
        endcase
    end
end

// Counter management with clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= R_T;
    end else if (counter_enable) begin
        if (state[3] && pass_request && (cnt > MIN_G))
            cnt <= MIN_G;
        else if (cnt == 1) begin
            case (1'b1)
                state[1]: cnt <= G_T;
                state[2]: cnt <= R_T;
                state[3]: cnt <= Y_T;
                default: cnt <= R_T;
            endcase
        end else
            cnt <= cnt - 1;
    end
end

// Combined output assignments
always @(*) begin
    red = state[1];
    yellow = state[2];
    green = state[3];
end

assign clock = cnt;

endmodule