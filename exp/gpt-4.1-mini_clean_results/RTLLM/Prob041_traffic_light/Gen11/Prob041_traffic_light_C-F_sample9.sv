module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg [7:0]  clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

// State encoding
localparam RED    = 2'd0;
localparam GREEN  = 2'd1;
localparam YELLOW = 2'd2;

// Timing constants
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state;
reg [7:0] timer;

wire timer_en = (timer != 0);
wire apply_shortening = (state == GREEN) && pass_request && (timer > SHORT_GREEN);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
    end else begin
        if (timer == 0) begin
            case (state)
                RED:    state <= GREEN;
                GREEN:  state <= YELLOW;
                YELLOW: state <= RED;
                default: state <= RED;
            endcase
            case (state)
                RED:    timer <= GREEN_TIME;
                GREEN:  timer <= YELLOW_TIME;
                YELLOW: timer <= RED_TIME;
                default: timer <= RED_TIME;
            endcase
        end else begin
            if (apply_shortening)
                timer <= SHORT_GREEN;
            else if (timer_en)
                timer <= timer - 1;
        end
    end
end

always @(*) begin
    red    = (state == RED);
    yellow = (state == YELLOW);
    green  = (state == GREEN);
    clock  = timer;
end

endmodule