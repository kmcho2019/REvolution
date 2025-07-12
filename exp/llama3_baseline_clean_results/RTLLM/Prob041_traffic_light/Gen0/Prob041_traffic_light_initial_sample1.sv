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
        idle: begin
            state = s1_red;
        end
        s1_red: begin
            if(cnt == 0) begin
                state = s3_green;
            end else begin
                state = s1_red;
            end
        end
        s2_yellow: begin
            if(cnt == 0) begin
                state = s1_red;
            end else begin
                state = s2_yellow;
            end
        end
        s3_green: begin
            if(cnt == 0) begin
                state = s2_yellow;
            end else begin
                state = s3_green;
            end
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt <= 10;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        if(pass_request && p_green) begin
            cnt <= 10;
        end else if(!p_green && p_green == 1) begin
            cnt <= 60;
        end else if(!p_yellow && p_yellow == 1) begin
            cnt <= 5;
        end else if(!p_red && p_red == 1) begin
            cnt <= 10;
        end else begin
            cnt <= cnt - 1;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        case(state)
            idle: begin
                p_red <= 0;
                p_yellow <= 0;
                p_green <= 0;
            end
            s1_red: begin
                p_red <= 1;
                p_yellow <= 0;
                p_green <= 0;
            end
            s2_yellow: begin
                p_red <= 0;
                p_yellow <= 1;
                p_green <= 0;
            end
            s3_green: begin
                p_red <= 0;
                p_yellow <= 0;
                p_green <= 1;
            end
        endcase
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

assign clock = cnt;

endmodule