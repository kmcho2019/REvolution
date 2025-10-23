module traffic_light(
    input rst_n, 
    input clk, 
    input pass_request,
    output [7:0] clock,
    output red, 
    output yellow, 
    output green
);

parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

always @(*) begin
    case(state)
        idle: state = s1_red;
        s1_red: if (cnt == 0) state = s3_green; else state = s1_red;
        s2_yellow: if (cnt == 0) state = s1_red; else state = s2_yellow;
        s3_green: if (cnt == 0) state = s2_yellow; else state = s3_green;
        default: state = idle;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        if (pass_request && p_green) begin
            cnt <= 10;
        end else if (!p_green && p_green) begin
            cnt <= 60;
        end else if (!p_yellow && p_yellow) begin
            cnt <= 5;
        end else if (!p_red && p_red) begin
            cnt <= 10;
        end else begin
            if (cnt > 0) begin
                cnt <= cnt - 1;
            end
        end
        case(state)
            s1_red: begin
                p_red <= 1'b1;
                p_yellow <= 1'b0;
                p_green <= 1'b0;
            end
            s2_yellow: begin
                p_red <= 1'b0;
                p_yellow <= 1'b1;
                p_green <= 1'b0;
            end
            s3_green: begin
                p_red <= 1'b0;
                p_yellow <= 1'b0;
                p_green <= 1'b1;
            end
            default: begin
                p_red <= 1'b0;
                p_yellow <= 1'b0;
                p_green <= 1'b0;
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