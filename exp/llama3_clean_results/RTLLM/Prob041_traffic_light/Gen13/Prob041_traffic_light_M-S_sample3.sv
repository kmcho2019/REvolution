module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

reg [7:0] cnt;
reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
        cnt <= 10;
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        case (state)
            2'b00: begin // idle
                state <= 2'b01;
                cnt <= 60;
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
            2'b01: begin // red
                if (cnt == 0) begin
                    state <= 2'b11;
                    cnt <= 60;
                end else if (pass_request && cnt > 10) begin
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            2'b10: begin // yellow
                if (cnt == 0) begin
                    state <= 2'b01;
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
                yellow <= 1;
                red <= 0;
                green <= 0;
            end
            2'b11: begin // green
                if (cnt == 0) begin
                    state <= 2'b10;
                    cnt <= 5;
                end else if (pass_request && cnt > 10) begin
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
                green <= 1;
                red <= 0;
                yellow <= 0;
            end
        endcase
    end
end

assign clock = cnt;

endmodule