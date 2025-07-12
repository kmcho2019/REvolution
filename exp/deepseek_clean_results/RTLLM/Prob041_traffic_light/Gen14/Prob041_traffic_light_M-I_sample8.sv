module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output [1:0] light // 00:red, 01:yellow, 10:green
);

parameter RED_TIME = 10;
parameter YELLOW_TIME = 5;
parameter GREEN_TIME = 60;
parameter MIN_GREEN = 10;

reg [5:0] cnt;
reg [2:0] state; // one-hot: [0]=red, [1]=yellow, [2]=green
reg cnt_en; // clock gating signal

// Output encoding
assign light = state[0] ? 2'b00 : 
               state[1] ? 2'b01 : 2'b10;
assign clock = cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 3'b001; // red
        cnt <= RED_TIME;
        cnt_en <= 1'b1;
    end else begin
        // Early evaluation of pedestrian request
        if (pass_request && state[2] && cnt > MIN_GREEN) begin
            cnt <= MIN_GREEN;
            cnt_en <= 1'b1;
        end
        
        if (cnt_en) begin
            if (cnt == 0) begin
                // State transition
                case (1'b1)
                    state[0]: begin // red->green
                        state <= 3'b100;
                        cnt <= GREEN_TIME;
                    end
                    state[1]: begin // yellow->red
                        state <= 3'b001;
                        cnt <= RED_TIME;
                    end
                    state[2]: begin // green->yellow
                        state <= 3'b010;
                        cnt <= YELLOW_TIME;
                    end
                endcase
                cnt_en <= 1'b1;
            end else begin
                cnt <= cnt - 1;
                // Disable counter when not needed
                cnt_en <= !((state[2] && cnt > MIN_GREEN) || 
                           (state[1] && cnt > 1) || 
                           (state[0] && cnt > 1));
            end
        end
    end
end

endmodule