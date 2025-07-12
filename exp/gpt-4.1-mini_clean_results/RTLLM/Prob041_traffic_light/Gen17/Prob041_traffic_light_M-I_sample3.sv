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
localparam IDLE   = 2'd0;  // Not used as per original spec but defined
localparam S1_RED = 2'd1;
localparam S2_YELLOW = 2'd2;
localparam S3_GREEN = 2'd3;

// Timing constants
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state;
reg [7:0] cnt;

// Timer enable: only decrement when counter > 0
wire timer_en = (cnt != 0);

// Pedestrian shortening condition: 
// If green is active and pass_request asserted and cnt>10, shorten to 10
wire shorten_green = (state == S3_GREEN) && pass_request && (cnt > SHORT_GREEN);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S1_RED;
        cnt <= RED_TIME;
    end else begin
        case (state)
            S1_RED: begin
                if (timer_en)
                    cnt <= cnt - 1;
                if (cnt == 0) begin
                    state <= S3_GREEN;
                    cnt <= GREEN_TIME;
                end
            end

            S3_GREEN: begin
                if (shorten_green)
                    cnt <= SHORT_GREEN;
                else if (timer_en)
                    cnt <= cnt - 1;

                if (cnt == 0) begin
                    state <= S2_YELLOW;
                    cnt <= YELLOW_TIME;
                end
            end

            S2_YELLOW: begin
                if (timer_en)
                    cnt <= cnt - 1;
                if (cnt == 0) begin
                    state <= S1_RED;
                    cnt <= RED_TIME;
                end
            end

            default: begin
                state <= S1_RED;
                cnt <= RED_TIME;
            end
        endcase
    end
end

// Outputs combinationally from state
always @(*) begin
    red    = (state == S1_RED);
    yellow = (state == S2_YELLOW);
    green  = (state == S3_GREEN);
    clock  = cnt;
end

endmodule