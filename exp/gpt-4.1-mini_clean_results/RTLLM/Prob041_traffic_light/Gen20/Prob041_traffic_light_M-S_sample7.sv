module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // Timing parameters
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_SHORT = 8'd10;

    // States encoding
    localparam idle     = 2'd0;
    localparam s1_red   = 2'd1;
    localparam s2_yellow= 2'd2;
    localparam s3_green = 2'd3;

    reg [1:0] state;
    reg [7:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 8'd0;
        end else begin
            case(state)
                idle: begin
                    state <= s1_red;
                    cnt <= RED_TIME;
                end
                s1_red: begin
                    if (cnt == 0) begin
                        state <= s3_green;
                        cnt <= GREEN_TIME;
                    end else
                        cnt <= cnt - 1;
                end
                s3_green: begin
                    // Shorten green if pass_request pressed and remaining green > GREEN_SHORT
                    if (pass_request && (cnt > GREEN_SHORT))
                        cnt <= GREEN_SHORT;
                    else if (cnt == 0) begin
                        state <= s2_yellow;
                        cnt <= YELLOW_TIME;
                    end else
                        cnt <= cnt - 1;
                end
                s2_yellow: begin
                    if (cnt == 0) begin
                        state <= s1_red;
                        cnt <= RED_TIME;
                    end else
                        cnt <= cnt - 1;
                end
                default: begin
                    state <= idle;
                    cnt <= 8'd0;
                end
            endcase
        end
    end

    // Assign outputs based on current state
    assign red    = (state == s1_red);
    assign yellow = (state == s2_yellow);
    assign green  = (state == s3_green);

    // Output current counter
    always @(*) begin
        clock = cnt;
    end

endmodule