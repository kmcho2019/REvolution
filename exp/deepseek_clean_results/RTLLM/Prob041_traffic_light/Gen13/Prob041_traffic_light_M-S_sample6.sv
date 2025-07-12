module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output red,
    output yellow,
    output green
);

reg [1:0] state;  // 00:red, 01:yellow, 10:green
reg [5:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;  // Start in red state
        cnt <= 10;       // Red time
    end else begin
        cnt <= cnt - 1;
        
        if (cnt == 1) begin
            case (state)
                2'b00: begin  // red -> green
                    state <= 2'b10;
                    cnt <= 60;
                end
                2'b01: begin  // yellow -> red
                    state <= 2'b00;
                    cnt <= 10;
                end
                2'b10: begin  // green -> yellow
                    state <= 2'b01;
                    cnt <= 5;
                end
            endcase
        end else if (state == 2'b10 && pass_request && cnt > 10) begin
            cnt <= 10;  // Shorten green time if requested
        end
    end
end

assign clock = cnt;
assign {red, yellow, green} = (state == 2'b00) ? 3'b100 :
                              (state == 2'b01) ? 3'b010 :
                              (state == 2'b10) ? 3'b001 : 3'b000;

endmodule