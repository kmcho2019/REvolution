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
    localparam IDLE     = 2'd0;
    localparam RED_S    = 2'd1;
    localparam YELLOW_S = 2'd2;
    localparam GREEN_S  = 2'd3;

    // Timing constants
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam SHORT_GREEN = 8'd10;

    reg [1:0] state;
    reg [7:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state  <= IDLE;
            cnt    <= 8'd0;
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
            clock  <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    state  <= RED_S;
                    cnt    <= RED_TIME;
                    red    <= 1'b1;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
                RED_S: begin
                    if (cnt == 0) begin
                        state  <= GREEN_S;
                        cnt    <= GREEN_TIME;
                        red    <= 1'b0;
                        yellow <= 1'b0;
                        green  <= 1'b1;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                GREEN_S: begin
                    if (pass_request && cnt > SHORT_GREEN) begin
                        cnt <= SHORT_GREEN;
                    end else if (cnt == 0) begin
                        state  <= YELLOW_S;
                        cnt    <= YELLOW_TIME;
                        red    <= 1'b0;
                        yellow <= 1'b1;
                        green  <= 1'b0;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                YELLOW_S: begin
                    if (cnt == 0) begin
                        state  <= RED_S;
                        cnt    <= RED_TIME;
                        red    <= 1'b1;
                        yellow <= 1'b0;
                        green  <= 1'b0;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                default: begin
                    state  <= IDLE;
                    cnt    <= 8'd0;
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
            endcase
            clock <= cnt;
        end
    end

endmodule