module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Timing parameters
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// State encoding
localparam IDLE = 2'b00;
localparam RED = 2'b01;
localparam YELLOW = 2'b10;
localparam GREEN = 2'b11;

reg [1:0] state;
reg [7:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt <= RED_TIME;
        {red, yellow, green} <= 3'b000;
    end else begin
        // Handle counter
        if (pass_request && (state == GREEN) && (cnt > MIN_GREEN))
            cnt <= MIN_GREEN;
        else if (cnt == 1) begin
            case (state)
                RED:    cnt <= GREEN_TIME;
                YELLOW: cnt <= RED_TIME;
                GREEN:  cnt <= YELLOW_TIME;
                default: cnt <= RED_TIME;
            endcase
        end else
            cnt <= cnt - 1;

        // State transition and outputs
        case (state)
            IDLE: begin
                state <= RED;
                {red, yellow, green} <= 3'b100;
            end
            RED: if (cnt == 1) begin
                state <= GREEN;
                {red, yellow, green} <= 3'b001;
            end
            YELLOW: if (cnt == 1) begin
                state <= RED;
                {red, yellow, green} <= 3'b100;
            end
            GREEN: if (cnt == 1) begin
                state <= YELLOW;
                {red, yellow, green} <= 3'b010;
            end
        endcase
    end
end

assign clock = cnt;

endmodule