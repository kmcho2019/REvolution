module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

reg [1:0] state;
reg [7:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
        cnt <= 8'd60;
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        case (state)
            2'b00: begin // idle
                red <= 0;
                yellow <= 0;
                green <= 0;
                if (cnt == 0) begin
                    state <= 2'b01;
                    cnt <= 8'd60;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            2'b01: begin // red
                red <= 1;
                yellow <= 0;
                green <= 0;
                if (cnt == 0) begin
                    state <= 2'b10;
                    cnt <= 8'd5;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            2'b10: begin // yellow
                red <= 0;
                yellow <= 1;
                green <= 0;
                if (cnt == 0) begin
                    state <= 2'b11;
                    cnt <= 8'd60;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            2'b11: begin // green
                red <= 0;
                yellow <= 0;
                green <= 1;
                if (pass_request && cnt > 8'd10) begin
                    cnt <= 8'd10;
                end else if (cnt == 0) begin
                    state <= 2'b01;
                    cnt <= 8'd10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            default: begin
                state <= 2'b00;
                cnt <= 8'd60;
                red <= 0;
                yellow <= 0;
                green <= 0;
            end
        endcase
    end
end

assign clock = cnt;

endmodule