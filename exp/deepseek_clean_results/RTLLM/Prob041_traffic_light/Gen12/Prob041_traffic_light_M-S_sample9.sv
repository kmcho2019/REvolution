module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

reg [1:0] state;
reg [5:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00; // RED
        cnt <= 10;
        red <= 1;
        yellow <= 0;
        green <= 0;
    end else begin
        // Handle counter
        if (cnt == 0) begin
            case (state)
                2'b00: begin // RED -> GREEN
                    state <= 2'b10;
                    cnt <= 60;
                    red <= 0;
                    green <= 1;
                end
                2'b01: begin // YELLOW -> RED
                    state <= 2'b00;
                    cnt <= 10;
                    yellow <= 0;
                    red <= 1;
                end
                2'b10: begin // GREEN -> YELLOW
                    state <= 2'b01;
                    cnt <= 5;
                    green <= 0;
                    yellow <= 1;
                end
            endcase
        end else begin
            // Handle pedestrian request
            if (pass_request && state == 2'b10 && cnt > 10) begin
                cnt <= 10;
            end else begin
                cnt <= cnt - 1;
            end
        end
        clock <= cnt;
    end
end

endmodule