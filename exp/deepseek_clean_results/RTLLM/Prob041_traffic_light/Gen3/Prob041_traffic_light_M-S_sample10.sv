module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Timing parameters
parameter RED_TIME   = 8'd10;
parameter YELLOW_TIME = 8'd5;
parameter GREEN_TIME = 8'd60;
parameter MIN_GREEN  = 8'd10;

// State definitions
parameter IDLE  = 2'b00;
parameter RED   = 2'b01;
parameter YELLOW = 2'b10;
parameter GREEN = 2'b11;

reg [1:0] state;
reg [7:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt <= RED_TIME;
        {red, yellow, green} <= 3'b000;
    end else begin
        case (state)
            IDLE: begin
                state <= RED;
                cnt <= RED_TIME;
                {red, yellow, green} <= 3'b100;
            end
            
            RED: begin
                if (cnt == 1) begin
                    state <= GREEN;
                    cnt <= GREEN_TIME;
                    {red, yellow, green} <= 3'b001;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            YELLOW: begin
                if (cnt == 1) begin
                    state <= RED;
                    cnt <= RED_TIME;
                    {red, yellow, green} <= 3'b100;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            GREEN: begin
                // Handle pedestrian request
                if (pass_request && (cnt > MIN_GREEN)) begin
                    cnt <= MIN_GREEN;
                end
                // Normal countdown
                if (cnt == 1) begin
                    state <= YELLOW;
                    cnt <= YELLOW_TIME;
                    {red, yellow, green} <= 3'b010;
                end else begin
                    cnt <= cnt - 1;
                end
            end
        endcase
        clock <= cnt;
    end
end

endmodule