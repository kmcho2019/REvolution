module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [4:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding with one-hot attributes
(* onehot *) parameter s1_red    = 2'b00;
(* onehot *) parameter s2_yellow = 2'b01;
(* onehot *) parameter s3_green  = 2'b10;

reg [1:0] state;
reg [4:0] cnt;
wire counter_enable;

// Counter enable logic - only count down when not in transition
assign counter_enable = (cnt != 1);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= s1_red;
        cnt <= 5'd10;
        red <= 1'b1;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        // Register outputs for better timing
        red <= (state == s1_red);
        yellow <= (state == s2_yellow);
        green <= (state == s3_green);
        
        case (state)
            s1_red: begin
                if (counter_enable) begin
                    cnt <= cnt - 1;
                end else begin
                    state <= s3_green;
                    cnt <= 5'd60;
                end
            end
            
            s2_yellow: begin
                if (counter_enable) begin
                    cnt <= cnt - 1;
                end else begin
                    state <= s1_red;
                    cnt <= 5'd10;
                end
            end
            
            s3_green: begin
                if (pass_request && cnt > 10 && green) begin
                    cnt <= 5'd10;
                end
                else if (counter_enable) begin
                    cnt <= cnt - 1;
                end else begin
                    state <= s2_yellow;
                    cnt <= 5'd5;
                end
            end
            
            default: begin
                state <= s1_red;
                cnt <= 5'd10;
            end
        endcase
    end
end

assign clock = cnt;

endmodule