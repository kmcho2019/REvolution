module traffic_light(
    input  logic rst_n,
    input  logic clk,
    input  logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

logic [7:0] cnt;
logic [1:0] state;
logic p_red, p_yellow, p_green;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: if (cnt == 0) state <= s3_green;
            s2_yellow: if (cnt == 0) state <= s1_red;
            s3_green: if (cnt == 0) state <= s2_yellow;
            default: state <= state;
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        p_red <= 1'b1;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        case (state)
            s1_red: if (cnt == 0) begin
                p_red <= 1'b0;
                p_yellow <= 1'b0;
                p_green <= 1'b1;
            end else if (cnt > 0) begin
                cnt <= cnt - 1;
                p_red <= 1'b1;
                p_yellow <= 1'b0;
                p_green <= 1'b0;
            end
            s2_yellow: if (cnt == 0) begin
                p_red <= 1'b1;
                p_yellow <= 1'b0;
                p_green <= 1'b0;
            end else if (cnt > 0) begin
                cnt <= cnt - 1;
                p_red <= 1'b0;
                p_yellow <= 1'b1;
                p_green <= 1'b0;
            end
            s3_green: if (pass_request && cnt > 10) begin
                cnt <= 10;
                p_red <= 1'b0;
                p_yellow <= 1'b0;
                p_green <= 1'b1;
            end else if (cnt == 0) begin
                p_red <= 1'b0;
                p_yellow <= 1'b1;
                p_green <= 1'b0;
            end else if (cnt > 0) begin
                cnt <= cnt - 1;
                p_red <= 1'b0;
                p_yellow <= 1'b0;
                p_green <= 1'b1;
            end
            default: begin
                cnt <= cnt;
                p_red <= p_red;
                p_yellow <= p_yellow;
                p_green <= p_green;
            end
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

assign clock = cnt;

endmodule