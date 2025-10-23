module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output wire [6:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
);

localparam [1:0]
    RED    = 2'b00,
    GREEN  = 2'b01,
    YELLOW = 2'b10;

localparam [6:0]
    RED_TIME    = 7'd10,
    YELLOW_TIME = 7'd5,
    GREEN_TIME  = 7'd60,
    SHORT_GREEN = 7'd10;

reg [1:0] state;
reg [6:0] timer;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
    end else begin
        case (state)
            RED: begin
                if (timer == 7'd0) begin
                    state <= GREEN;
                    timer <= GREEN_TIME;
                end else begin
                    timer <= timer - 1;
                end
            end

            GREEN: begin
                // Determine next timer value, shortening if pass_request and timer > SHORT_GREEN
                if (pass_request && (timer > SHORT_GREEN)) begin
                    // Shorten timer to SHORT_GREEN
                    timer <= SHORT_GREEN - 1;
                    state <= GREEN;
                end else if (timer == 7'd0) begin
                    state <= YELLOW;
                    timer <= YELLOW_TIME;
                end else begin
                    timer <= timer - 1;
                end
            end

            YELLOW: begin
                if (timer == 7'd0) begin
                    state <= RED;
                    timer <= RED_TIME;
                end else begin
                    timer <= timer - 1;
                end
            end

            default: begin
                state <= RED;
                timer <= RED_TIME;
            end
        endcase
    end
end

assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);
assign clock  = timer;

endmodule