module traffic_light(
    input rst_n, clk, pass_request,
    output [7:0] clock,
    output reg red, output reg yellow, output reg green
);

    reg [1:0] state;
    reg [7:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b00; // red
            cnt <= 10;
            red <= 1;
            yellow <= 0;
            green <= 0;
        end else begin
            case (state)
                2'b00: begin // red
                    red <= 1;
                    yellow <= 0;
                    green <= 0;
                    if (cnt == 0) begin
                        state <= 2'b01; // green
                        cnt <= 60;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                2'b01: begin // green
                    red <= 0;
                    yellow <= 0;
                    green <= 1;
                    if (pass_request && cnt > 10) begin
                        cnt <= 10;
                    end
                    if (cnt == 0) begin
                        state <= 2'b10; // yellow
                        cnt <= 5;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                2'b10: begin // yellow
                    red <= 0;
                    yellow <= 1;
                    green <= 0;
                    if (cnt == 0) begin
                        state <= 2'b00; // red
                        cnt <= 10;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
            endcase
        end
    end

    assign clock = cnt;

endmodule