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
localparam GREEN = 2'b10;
localparam YELLOW = 2'b11;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt <= 10;
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
                if (cnt == 0 || (pass_request && cnt > 10)) begin
                    if (pass_request && cnt > 10) begin
                        cnt <= 10;
                    end else begin
                        state <= YELLOW;
                        cnt <= 5;
                    end
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
    end
end

assign clock = cnt;
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);

endmodule