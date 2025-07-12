`define idle 2'b00
`define s1_red 2'b01
`define s2_yellow 2'b10
`define s3_green 2'b11

module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= `idle;
    end else begin
        case (state)
            `idle: state <= `s1_red;
            `s1_red: if (cnt == 0) state <= `s3_green;
            `s2_yellow: if (cnt == 0) state <= `s1_red;
            `s3_green: if (cnt == 0) state <= `s2_yellow;
            default: state <= state;
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        if (pass_request && p_green) begin
            cnt <= 8'd10;
        end else if (!p_green && p_green != green) begin
            cnt <= 8'd60;
        end else if (!p_yellow && p_yellow != yellow) begin
            cnt <= 8'd5;
        end else if (!p_red && p_red != red) begin
            cnt <= 8'd10;
        end else begin
            cnt <= cnt - 1;
        end
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        case (state)
            `idle: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            `s1_red: begin
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            `s2_yellow: begin
                red <= 1'b0;
                yellow <= 1'b1;
                green <= 1'b0;
            end
            `s3_green: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b1;
            end
            default: begin
                red <= red;
                yellow <= yellow;
                green <= green;
            end
        endcase
    end
end

assign clock = cnt;

endmodule