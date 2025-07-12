module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output red,
    output yellow,
    output green
);

parameter s1_red    = 2'b00;
parameter s2_yellow = 2'b01;
parameter s3_green  = 2'b10;

reg [1:0] state;
reg [5:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= s1_red;
        cnt <= 6'd10;
    end else begin
        cnt <= cnt - 1;
        case (state)
            s1_red:    if (cnt == 1) begin state <= s3_green; cnt <= 6'd60; end
            s2_yellow: if (cnt == 1) begin state <= s1_red;  cnt <= 6'd10; end
            s3_green:  begin
                if (pass_request && cnt > 10) cnt <= 6'd10;
                if (cnt == 1) begin state <= s2_yellow; cnt <= 6'd5; end
            end
        endcase
    end
end

assign {red, yellow, green} = (state == s1_red)    ? 3'b100 :
                              (state == s2_yellow) ? 3'b010 :
                              (state == s3_green)  ? 3'b001 : 3'b000;
assign clock = cnt;

endmodule