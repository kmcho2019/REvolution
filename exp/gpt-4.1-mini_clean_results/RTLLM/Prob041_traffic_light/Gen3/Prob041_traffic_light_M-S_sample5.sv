module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output [7:0] clock,
    output reg   red,
    output reg   yellow,
    output reg   green
);

    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_SHORT = 8'd10;

    typedef enum reg [1:0] {
        S_RED    = 2'd0,
        S_GREEN  = 2'd1,
        S_YELLOW = 2'd2
    } state_t;

    state_t state;
    reg [7:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_RED;
            cnt   <= RED_TIME;
        end else begin
            if (cnt == 0) begin
                case(state)
                    S_RED: begin
                        state <= S_GREEN;
                        cnt   <= GREEN_TIME;
                    end
                    S_GREEN: begin
                        state <= S_YELLOW;
                        cnt   <= YELLOW_TIME;
                    end
                    S_YELLOW: begin
                        state <= S_RED;
                        cnt   <= RED_TIME;
                    end
                    default: begin
                        state <= S_RED;
                        cnt   <= RED_TIME;
                    end
                endcase
            end else begin
                if (state == S_GREEN && pass_request && (cnt > GREEN_SHORT)) begin
                    cnt <= GREEN_SHORT;
                end else begin
                    cnt <= cnt - 1;
                end
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
        end else begin
            red    <= (state == S_RED);
            yellow <= (state == S_YELLOW);
            green  <= (state == S_GREEN);
        end
    end

    assign clock = cnt;

endmodule