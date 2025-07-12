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

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        state <= idle;
        cnt <= 8'd60;
    end
    else
    begin
        case (state)
            idle:
            begin
                state <= s1_red;
            end
            s1_red:
            begin
                if (cnt == 8'd0)
                begin
                    state <= s3_green;
                    cnt <= 8'd60;
                end
            end
            s2_yellow:
            begin
                if (cnt == 8'd0)
                begin
                    state <= s1_red;
                    cnt <= 8'd10;
                end
            end
            s3_green:
            begin
                if (cnt == 8'd0)
                begin
                    state <= s2_yellow;
                    cnt <= 8'd5;
                end
                else if (pass_request && (cnt > 8'd10))
                begin
                    cnt <= 8'd10;
                end
            end
        endcase
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        cnt <= 8'd10;
    end
    else
    begin
        case (state)
            s1_red:
            begin
                if (p_red)
                begin
                    cnt <= 8'd10;
                end
            end
            s2_yellow:
            begin
                if (p_yellow)
                begin
                    cnt <= 8'd5;
                end
            end
            s3_green:
            begin
                if (p_green)
                begin
                    cnt <= 8'd60;
                end
                else if (pass_request && (cnt > 8'd10))
                begin
                    cnt <= 8'd10;
                end
            end
        endcase
        if (pass_request && (state == s3_green) && (cnt > 8'd10))
        begin
            cnt <= 8'd10;
        end
        else
        begin
            cnt <= cnt - 1;
        end
    end
end

assign clock = cnt;

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end
    else
    begin
        case (state)
            idle:
            begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            s1_red:
            begin
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            s2_yellow:
            begin
                red <= 1'b0;
                yellow <= 1'b1;
                green <= 1'b0;
            end
            s3_green:
            begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b1;
            end
        endcase
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

endmodule