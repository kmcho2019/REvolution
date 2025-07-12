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
    localparam GREEN_MIN   = 8'd10;

    // State encoding
    localparam IDLE  = 2'd0;
    localparam REDS  = 2'd1;
    localparam YELLO = 2'd2;
    localparam GREEN = 2'd3;

    reg [1:0] state;
    reg [7:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= RED_TIME;
            clock <= RED_TIME;
        end else begin
            case (state)
                IDLE: begin
                    state <= REDS;
                    cnt <= RED_TIME;
                    clock <= RED_TIME;
                end

                REDS: begin
                    if (cnt == 0) begin
                        state <= GREEN;
                        cnt <= GREEN_TIME;
                    end else begin
                        cnt <= cnt - 1;
                    end
                    clock <= cnt;
                end

                GREEN: begin
                    if (pass_request && cnt > GREEN_MIN)
                        cnt <= GREEN_MIN;
                    else if (cnt == 0) begin
                        state <= YELLO;
                        cnt <= YELLOW_TIME;
                    end else begin
                        cnt <= cnt - 1;
                    end
                    clock <= cnt;
                end

                YELLO: begin
                    if (cnt == 0) begin
                        state <= REDS;
                        cnt <= RED_TIME;
                    end else begin
                        cnt <= cnt - 1;
                    end
                    clock <= cnt;
                end

                default: begin
                    state <= IDLE;
                    cnt <= RED_TIME;
                    clock <= RED_TIME;
                end
            endcase
        end
    end

    // Output signals derived from state
    assign red    = (state == REDS);
    assign yellow = (state == YELLO);
    assign green  = (state == GREEN);

endmodule