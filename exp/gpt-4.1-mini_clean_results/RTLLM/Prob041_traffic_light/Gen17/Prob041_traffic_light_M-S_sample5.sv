module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [7:0] clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

    // State encoding
    localparam IDLE    = 2'd0;
    localparam RED     = 2'd1;
    localparam YELLOW  = 2'd2;
    localparam GREEN   = 2'd3;

    // Timing parameters
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam SHORT_GREEN = 8'd10;

    reg [1:0] state;
    reg [7:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= RED;
            cnt   <= RED_TIME;
        end else begin
            if (state == GREEN && pass_request && cnt > SHORT_GREEN) begin
                cnt <= SHORT_GREEN;
            end else if (cnt == 0) begin
                case(state)
                    RED: begin
                        state <= GREEN;
                        cnt <= GREEN_TIME;
                    end
                    GREEN: begin
                        state <= YELLOW;
                        cnt <= YELLOW_TIME;
                    end
                    YELLOW: begin
                        state <= RED;
                        cnt <= RED_TIME;
                    end
                    default: begin
                        state <= RED;
                        cnt <= RED_TIME;
                    end
                endcase
            end else begin
                cnt <= cnt - 1;
            end
        end
    end

    always @(*) begin
        red    = (state == RED);
        yellow = (state == YELLOW);
        green  = (state == GREEN);
        clock  = cnt;
    end

endmodule