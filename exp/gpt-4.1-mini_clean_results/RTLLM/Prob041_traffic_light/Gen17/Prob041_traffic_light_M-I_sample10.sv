module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output wire [7:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
);

    // State encoding
    localparam IDLE    = 2'd0;
    localparam RED     = 2'd1;
    localparam YELLOW  = 2'd2;
    localparam GREEN   = 2'd3;

    // Timing constants
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam SHORT_GREEN = 8'd10;

    reg [1:0] state;
    reg [7:0] cnt;

    // State machine and counter update with synchronous reset
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= RED;
            cnt   <= RED_TIME;
        end else begin
            case(state)
                RED: begin
                    if (cnt == 0) begin
                        state <= GREEN;
                        cnt <= GREEN_TIME;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                GREEN: begin
                    if (pass_request && (cnt > SHORT_GREEN)) begin
                        cnt <= SHORT_GREEN;
                    end else if (cnt == 0) begin
                        state <= YELLOW;
                        cnt <= YELLOW_TIME;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                YELLOW: begin
                    if (cnt == 0) begin
                        state <= RED;
                        cnt <= RED_TIME;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                default: begin
                    state <= RED;
                    cnt <= RED_TIME;
                end
            endcase
        end
    end

    // Outputs as continuous assignments derived from current state and count
    assign red    = (state == RED);
    assign yellow = (state == YELLOW);
    assign green  = (state == GREEN);
    assign clock  = cnt;

endmodule