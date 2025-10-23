module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

reg [1:0] state; // 00:red, 01:yellow, 10:green
reg [6:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00; // red
        cnt <= 7'd10;   // red time
    end else begin
        if (cnt == 0) begin
            case (state)
                2'b00: begin // red -> green
                    state <= 2'b10;
                    cnt <= 7'd60;
                end
                2'b01: begin // yellow -> red
                    state <= 2'b00;
                    cnt <= 7'd10;
                end
                2'b10: begin // green -> yellow
                    state <= 2'b01;
                    cnt <= 7'd5;
                end
            endcase
        end else begin
            if (pass_request && state == 2'b10 && cnt > 7'd10)
                cnt <= 7'd10;
            else
                cnt <= cnt - 1;
        end
    end
end

assign red = (state == 2'b00);
assign yellow = (state == 2'b01);
assign green = (state == 2'b10);
assign clock = cnt;

endmodule