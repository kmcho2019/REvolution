module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

enum logic [1:0] {
    idle,
    s1_red,
    s2_yellow,
    s3_green
} state, next_state;

logic [7:0] cnt;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 10;
    end else begin
        case (state)
            idle: begin
                state <= s1_red;
                cnt <= 10;
            end
            s1_red: begin
                if (cnt > 1) begin
                    state <= s1_red;
                    cnt <= cnt - 1;
                end else begin
                    state <= s3_green;
                    cnt <= 60;
                end
            end
            s3_green: begin
                if (pass_request && cnt > 10) begin
                    cnt <= 10;
                end
                if (cnt > 1) begin
                    state <= s3_green;
                    cnt <= cnt - 1;
                end else begin
                    state <= s2_yellow;
                    cnt <= 5;
                end
            end
            s2_yellow: begin
                if (cnt > 1) begin
                    state <= s2_yellow;
                    cnt <= cnt - 1;
                end else begin
                    state <= s1_red;
                    cnt <= 10;
                end
            end
            default: state <= idle;
        endcase
    end
end

assign clock = cnt;
assign red = (state == s1_red);
assign yellow = (state == s2_yellow);
assign green = (state == s3_green);

endmodule