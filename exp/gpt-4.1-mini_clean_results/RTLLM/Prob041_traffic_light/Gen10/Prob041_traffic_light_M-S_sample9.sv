module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [7:0] clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

localparam [1:0]
    S_RED    = 2'd0,
    S_GREEN  = 2'd1,
    S_YELLOW = 2'd2;

localparam [7:0]
    RED_TIME    = 8'd10,
    YELLOW_TIME = 8'd5,
    GREEN_TIME  = 8'd60,
    SHORT_GREEN = 8'd10;

reg [1:0] state;
reg [7:0] timer;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state  <= S_RED;
        timer  <= RED_TIME;
        red    <= 1'b1;
        yellow <= 1'b0;
        green  <= 1'b0;
        clock  <= RED_TIME;
    end else begin
        if (timer == 0) begin
            case (state)
                S_RED: begin
                    state  <= S_GREEN;
                    timer  <= GREEN_TIME;
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b1;
                    clock  <= GREEN_TIME;
                end
                S_GREEN: begin
                    state  <= S_YELLOW;
                    timer  <= YELLOW_TIME;
                    red    <= 1'b0;
                    yellow <= 1'b1;
                    green  <= 1'b0;
                    clock  <= YELLOW_TIME;
                end
                S_YELLOW: begin
                    state  <= S_RED;
                    timer  <= RED_TIME;
                    red    <= 1'b1;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                    clock  <= RED_TIME;
                end
                default: begin
                    state  <= S_RED;
                    timer  <= RED_TIME;
                    red    <= 1'b1;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                    clock  <= RED_TIME;
                end
            endcase
        end else begin
            // During green, if pass_request and timer > SHORT_GREEN, shorten timer to SHORT_GREEN
            if (state == S_GREEN && pass_request && timer > SHORT_GREEN)
                timer <= SHORT_GREEN;
            else
                timer <= timer - 1;
            clock <= timer - 1;
        end
    end
end

endmodule