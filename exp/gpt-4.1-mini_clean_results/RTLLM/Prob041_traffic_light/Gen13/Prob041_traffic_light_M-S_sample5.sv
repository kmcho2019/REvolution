module traffic_light (
    input         rst_n,
    input         clk,
    input         pass_request,
    output reg [7:0] clock,
    output        red,
    output        yellow,
    output        green
);

    // Timing constants
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_MIN   = 8'd10;

    // State encoding
    localparam IDLE    = 2'd0;
    localparam S1_RED  = 2'd1;
    localparam S2_YEL  = 2'd2;
    localparam S3_GRN  = 2'd3;

    reg [1:0] state;
    reg [7:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    state <= S1_RED;
                    cnt <= RED_TIME;
                end
                S1_RED: begin
                    if (cnt == 0) begin
                        state <= S3_GRN;
                        cnt <= GREEN_TIME;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                S2_YEL: begin
                    if (cnt == 0) begin
                        state <= S1_RED;
                        cnt <= RED_TIME;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                S3_GRN: begin
                    if (pass_request && cnt > GREEN_MIN) begin
                        cnt <= GREEN_MIN;
                    end else if (cnt == 0) begin
                        state <= S2_YEL;
                        cnt <= YELLOW_TIME;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                default: begin
                    state <= IDLE;
                    cnt <= 8'd0;
                end
            endcase
        end
    end

    // Output signals
    assign red    = (state == S1_RED);
    assign yellow = (state == S2_YEL);
    assign green  = (state == S3_GRN);

    // Current counter output
    always @(*) begin
        clock = cnt;
    end

endmodule