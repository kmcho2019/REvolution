module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

reg [1:0] state;
reg [7:0] cnt;

localparam RED    = 2'b00;
localparam YELLOW = 2'b01;
localparam GREEN  = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= 10;
    end else begin
        cnt <= cnt - 1;
        
        case (state)
            RED:    if (cnt == 1) begin state <= GREEN; cnt <= 60; end
            YELLOW: if (cnt == 1) begin state <= RED;   cnt <= 10; end
            GREEN:  begin
                if (pass_request && cnt > 10) cnt <= 10;
                if (cnt == 1) begin state <= YELLOW; cnt <= 5; end
            end
        endcase
    end
end

assign clock = cnt;
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);

endmodule