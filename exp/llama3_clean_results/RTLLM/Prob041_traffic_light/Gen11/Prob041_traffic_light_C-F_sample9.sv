module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

reg [5:0] cnt;
reg [1:0] state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
        cnt <= 6'd10;
    end else begin
        case (state)
            2'b00: begin // red
                if (cnt == 6'd0) begin
                    state <= 2'b10;
                    cnt <= 6'd60;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            2'b10: begin // green
                if (cnt == 6'd0) begin
                    state <= 2'b01;
                    cnt <= 6'd5;
                end else if (pass_request && cnt > 6'd10) begin
                    cnt <= 6'd10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            2'b01: begin // yellow
                if (cnt == 6'd0) begin
                    state <= 2'b00;
                    cnt <= 6'd10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        2'b00: begin
            red = 1'b1;
            yellow = 1'b0;
            green = 1'b0;
        end
        2'b10: begin
            red = 1'b0;
            yellow = 1'b0;
            green = 1'b1;
        end
        2'b01: begin
            red = 1'b0;
            yellow = 1'b1;
            green = 1'b0;
        end
    endcase
end

assign clock = cnt;

endmodule