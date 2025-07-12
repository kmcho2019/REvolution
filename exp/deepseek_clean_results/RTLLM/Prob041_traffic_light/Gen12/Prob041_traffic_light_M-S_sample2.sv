module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output red,
    output yellow,
    output green
);

reg [1:0] state;
reg [5:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00; // RED
        cnt <= 10;
    end else begin
        if (cnt == 0) begin
            case (state)
                2'b00: begin // RED
                    state <= 2'b10; // GREEN
                    cnt <= 60;
                end
                2'b01: begin // YELLOW
                    state <= 2'b00; // RED
                    cnt <= 10;
                end
                2'b10: begin // GREEN
                    state <= 2'b01; // YELLOW
                    cnt <= 5;
                end
            endcase
        end else begin
            if (pass_request && state == 2'b10 && cnt > 10) begin
                cnt <= 10;
            end else begin
                cnt <= cnt - 1;
            end
        end
    end
end

assign red = (state == 2'b00);
assign yellow = (state == 2'b01);
assign green = (state == 2'b10);
assign clock = cnt;

endmodule