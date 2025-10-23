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
localparam IDLE   = 2'd0;
localparam RED    = 2'd1;
localparam YELLOW = 2'd2;
localparam GREEN  = 2'd3;

// Timer constants
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state;
reg [7:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt <= 0;
    end else begin
        case(state)
            IDLE: begin
                // Initialize to RED state immediately
                state <= RED;
                cnt <= RED_TIME;
            end
            RED: begin
                if (cnt == 0) begin
                    state <= GREEN;
                    cnt <= GREEN_TIME;
                end else
                    cnt <= cnt - 1;
            end
            GREEN: begin
                if (pass_request && cnt > SHORT_GREEN)
                    cnt <= SHORT_GREEN;
                else if (cnt == 0) begin
                    state <= YELLOW;
                    cnt <= YELLOW_TIME;
                end else
                    cnt <= cnt - 1;
            end
            YELLOW: begin
                if (cnt == 0) begin
                    state <= RED;
                    cnt <= RED_TIME;
                end else
                    cnt <= cnt - 1;
            end
            default: begin
                state <= RED;
                cnt <= RED_TIME;
            end
        endcase
    end
end

always @(*) begin
    red    = (state == RED);
    yellow = (state == YELLOW);
    green  = (state == GREEN);
    clock  = cnt;
end

endmodule