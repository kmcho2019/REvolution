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
    typedef enum logic [1:0] {
        s1_red    = 2'b00,
        s3_green  = 2'b01,
        s2_yellow = 2'b10
    } state_t;

    state_t state;
    reg [7:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state  <= s1_red;
            cnt    <= 8'd10;
            red    <= 1'b1;
            yellow <= 1'b0;
            green  <= 1'b0;
        end else begin
            case(state)
                s1_red: begin
                    // Red light active
                    red    <= 1'b1;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                    if (cnt == 0) begin
                        state <= s3_green;
                        cnt   <= 8'd60;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end

                s3_green: begin
                    // Green light active
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b1;

                    // Shorten green if pass_request and remaining time > 10
                    if (pass_request && cnt > 10)
                        cnt <= 8'd10;
                    else if (cnt == 0) begin
                        state <= s2_yellow;
                        cnt   <= 8'd5;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end

                s2_yellow: begin
                    // Yellow light active
                    red    <= 1'b0;
                    yellow <= 1'b1;
                    green  <= 1'b0;
                    if (cnt == 0) begin
                        state <= s1_red;
                        cnt   <= 8'd10;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end

                default: begin
                    state  <= s1_red;
                    cnt    <= 8'd10;
                    red    <= 1'b1;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
            endcase
        end
    end

    assign clock = cnt;

endmodule