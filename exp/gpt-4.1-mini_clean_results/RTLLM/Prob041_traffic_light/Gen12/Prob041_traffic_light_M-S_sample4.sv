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
localparam [1:0]
    IDLE    = 2'b00,
    S1_RED  = 2'b01,
    S2_YELLOW = 2'b10,
    S3_GREEN  = 2'b11;

// Timing parameters
localparam [7:0]
    RED_TIME    = 8'd10,
    YELLOW_TIME = 8'd5,
    GREEN_TIME  = 8'd60,
    SHORT_GREEN = 8'd10;

reg [1:0] state;
reg [7:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state  <= IDLE;
        cnt    <= 8'd10;
        red    <= 1'b0;
        yellow <= 1'b0;
        green  <= 1'b0;
        clock  <= 8'd10;
    end else begin
        case(state)
            IDLE: begin
                red    <= 1'b0;
                yellow <= 1'b0;
                green  <= 1'b0;
                cnt    <= 8'd10;
                clock  <= cnt;
                state  <= S1_RED;
            end
            S1_RED: begin
                red    <= 1'b1;
                yellow <= 1'b0;
                green  <= 1'b0;
                if (cnt == 0) begin
                    cnt   <= GREEN_TIME;
                    state <= S3_GREEN;
                end else begin
                    cnt <= cnt - 1;
                end
                clock <= cnt;
            end
            S2_YELLOW: begin
                red    <= 1'b0;
                yellow <= 1'b1;
                green  <= 1'b0;
                if (cnt == 0) begin
                    cnt   <= RED_TIME;
                    state <= S1_RED;
                end else begin
                    cnt <= cnt - 1;
                end
                clock <= cnt;
            end
            S3_GREEN: begin
                red    <= 1'b0;
                yellow <= 1'b0;
                green  <= 1'b1;
                if (cnt == 0) begin
                    cnt   <= YELLOW_TIME;
                    state <= S2_YELLOW;
                end else begin
                    // If pedestrian button pressed and remaining green time > 10, shorten it
                    if (pass_request && (cnt > SHORT_GREEN)) begin
                        cnt <= SHORT_GREEN;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                clock <= cnt;
            end
            default: begin
                state <= IDLE;
                cnt   <= 8'd10;
                red    <= 1'b0;
                yellow <= 1'b0;
                green  <= 1'b0;
                clock  <= cnt;
            end
        endcase
    end
end

endmodule