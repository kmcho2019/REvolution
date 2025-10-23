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
    parameter RED    = 2'd0;
    parameter GREEN  = 2'd1;
    parameter YELLOW = 2'd2;

    // Timing parameters
    parameter RED_TIME    = 8'd10;
    parameter YELLOW_TIME = 8'd5;
    parameter GREEN_TIME  = 8'd60;
    parameter GREEN_SHORT = 8'd10;

    reg [1:0] state;
    reg [7:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= RED;
            cnt   <= RED_TIME;
            red   <= 1'b1;
            yellow<= 1'b0;
            green <= 1'b0;
        end else begin
            case(state)
                RED: begin
                    if (cnt == 0) begin
                        state <= GREEN;
                        cnt   <= GREEN_TIME - 1;
                        red   <= 1'b0;
                        green <= 1'b1;
                        yellow<= 1'b0;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end

                GREEN: begin
                    if (cnt == 0) begin
                        state <= YELLOW;
                        cnt   <= YELLOW_TIME - 1;
                        red   <= 1'b0;
                        green <= 1'b0;
                        yellow<= 1'b1;
                    end else begin
                        if (pass_request && cnt > GREEN_SHORT) begin
                            cnt <= GREEN_SHORT - 1;
                        end else begin
                            cnt <= cnt - 1;
                        end
                    end
                end

                YELLOW: begin
                    if (cnt == 0) begin
                        state <= RED;
                        cnt   <= RED_TIME - 1;
                        red   <= 1'b1;
                        green <= 1'b0;
                        yellow<= 1'b0;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end

                default: begin
                    state <= RED;
                    cnt   <= RED_TIME - 1;
                    red   <= 1'b1;
                    green <= 1'b0;
                    yellow<= 1'b0;
                end
            endcase
        end
    end

    assign clock = cnt;

endmodule