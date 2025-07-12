module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

localparam IDLE = 2'b00;
localparam RED = 2'b01;
localparam YELLOW = 2'b10;
localparam GREEN = 2'b11;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt <= 10;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        case (state)
            IDLE: begin
                state <= RED;
                cnt <= 10;
            end
            RED: begin
                if (cnt == 0) begin
                    state <= GREEN;
                    cnt <= 60;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            GREEN: begin
                if (cnt == 0) begin
                    state <= YELLOW;
                    cnt <= 5;
                end else if (pass_request && cnt > 10) begin
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            YELLOW: begin
                if (cnt == 0) begin
                    state <= RED;
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
        endcase
        p_red <= (state == RED);
        p_yellow <= (state == YELLOW);
        p_green <= (state == GREEN);
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

assign clock = cnt;

endmodule