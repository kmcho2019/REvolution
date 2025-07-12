module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output red,
    output yellow,
    output green
);

// State encoding
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
        case (state)
            s1_red: begin
                if (cnt == 1) begin
                    state <= s3_green;
                    cnt <= 6'd60;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            s2_yellow: begin
                if (cnt == 1) begin
                    state <= s1_red;
                    cnt <= 6'd10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            s3_green: begin
                if (pass_request && cnt > 10) begin
                    cnt <= 6'd10;
                end
                else if (cnt == 1) begin
                    state <= s2_yellow;
                    cnt <= 6'd5;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            default: begin
                state <= s1_red;
                cnt <= 6'd10;
            end
        endcase
    end
end

assign red = (state == s1_red);
assign yellow = (state == s2_yellow);
assign green = (state == s3_green);
assign clock = cnt;

endmodule