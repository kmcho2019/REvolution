module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Parameters
parameter G_T = 60;  // Green time
parameter Y_T = 5;   // Yellow time
parameter R_T = 10;  // Red time
parameter MIN_G = 10; // Minimum green time

// States
parameter IDLE = 0;
parameter RED = 1;
parameter YELLOW = 2;
parameter GREEN = 3;
reg [1:0] state;

// Counter
reg [7:0] cnt;

// State transition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE:   state <= RED;
            RED:    if (cnt == 1) state <= GREEN;
            YELLOW: if (cnt == 1) state <= RED;
            GREEN:  if (cnt == 1) state <= YELLOW;
        endcase
    end
end

// Counter management
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= R_T;
    end else begin
        if (pass_request && (state == GREEN) && (cnt > MIN_G))
            cnt <= MIN_G;
        else if (cnt == 1) begin
            case (state)
                RED:    cnt <= G_T;
                YELLOW: cnt <= R_T;
                GREEN:  cnt <= Y_T;
                default: cnt <= R_T;
            endcase
        end else
            cnt <= cnt - 1;
    end
end

// Output assignments
assign clock = cnt;
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);

endmodule