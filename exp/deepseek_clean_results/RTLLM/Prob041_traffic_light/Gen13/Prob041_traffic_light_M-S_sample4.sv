module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output red,
    output yellow,
    output green
);

reg [1:0] state; // 00:red, 01:yellow, 10:green
reg [5:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00; // red
        cnt <= 10;
    end else begin
        cnt <= cnt - 1;
        
        case (state)
            2'b00: if (cnt == 1) begin // red
                state <= 2'b10; // green
                cnt <= 60;
            end
            2'b01: if (cnt == 1) begin // yellow
                state <= 2'b00; // red
                cnt <= 10;
            end
            2'b10: begin // green
                if (pass_request && cnt > 10) cnt <= 10;
                if (cnt == 1) begin
                    state <= 2'b01; // yellow
                    cnt <= 5;
                end
            end
        endcase
    end
end

assign clock = cnt;
assign red = (state == 2'b00);
assign yellow = (state == 2'b01);
assign green = (state == 2'b10);

endmodule