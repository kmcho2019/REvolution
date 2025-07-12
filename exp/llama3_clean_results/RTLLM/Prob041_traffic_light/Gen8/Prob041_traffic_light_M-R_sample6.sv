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

localparam IDLE = 2'b00;
localparam RED = 2'b01;
localparam YELLOW = 2'b10;
localparam GREEN = 2'b11;

localparam RED_CNT = 10;
localparam GREEN_CNT = 60;
localparam YELLOW_CNT = 5;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt <= RED_CNT;
    end else begin
        case (state)
            IDLE: begin
                state <= RED;
                cnt <= RED_CNT;
            end
            RED: begin
                if (cnt == 0) begin
                    state <= GREEN;
                    cnt <= GREEN_CNT;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            GREEN: begin
                if (cnt == 0) begin
                    state <= YELLOW;
                    cnt <= YELLOW_CNT;
                end else if (pass_request && cnt > 10) begin
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            YELLOW: begin
                if (cnt == 0) begin
                    state <= RED;
                    cnt <= RED_CNT;
                end else begin
                    cnt <= cnt - 1;
                end
            end
        endcase
    end
end

assign clock = cnt;
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);

endmodule