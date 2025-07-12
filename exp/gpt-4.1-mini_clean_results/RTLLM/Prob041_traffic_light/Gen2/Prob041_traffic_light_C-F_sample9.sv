module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output [7:0] clock,
    output reg   red,
    output reg   yellow,
    output reg   green
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam S1_RED    = 2'd1;
    localparam S3_GREEN  = 2'd2;
    localparam S2_YELLOW = 2'd3;

    // Timing constants
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_SHORT = 8'd10;

    reg [1:0] state;
    reg [7:0] cnt;

    // State and counter update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S1_RED;
            cnt   <= RED_TIME;
        end else begin
            case (state)
                S1_RED: begin
                    if (cnt == 0) begin
                        state <= S3_GREEN;
                        cnt   <= GREEN_TIME;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end

                S3_GREEN: begin
                    // Shorten green if pedestrian request and remaining green time > 10
                    if (pass_request && (cnt > GREEN_SHORT)) begin
                        cnt <= GREEN_SHORT;
                    end else if (cnt == 0) begin
                        state <= S2_YELLOW;
                        cnt   <= YELLOW_TIME;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end

                S2_YELLOW: begin
                    if (cnt == 0) begin
                        state <= S1_RED;
                        cnt   <= RED_TIME;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end

                default: begin
                    state <= S1_RED;
                    cnt   <= RED_TIME;
                end
            endcase
        end
    end

    // Output logic: registered outputs for glitch-free signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
        end else begin
            case (state)
                S1_RED: begin
                    red    <= 1'b1;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end

                S3_GREEN: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b1;
                end

                S2_YELLOW: begin
                    red    <= 1'b0;
                    yellow <= 1'b1;
                    green  <= 1'b0;
                end

                default: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
            endcase
        end
    end

    // Assign counter to output clock
    assign clock = cnt;

endmodule