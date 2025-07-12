module traffic_light(
    input           rst_n,
    input           clk,
    input           pass_request,
    output  [7:0]   clock,
    output reg      red,
    output reg      yellow,
    output reg      green
);

    // State encoding
    localparam idle      = 2'd0;
    localparam s1_red    = 2'd1;
    localparam s2_yellow = 2'd2;
    localparam s3_green  = 2'd3;

    reg [7:0] cnt;
    reg [1:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 8'd10;
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
        end else begin
            case (state)
                idle: begin
                    // Transition immediately to red
                    state <= s1_red;
                    cnt <= 8'd10;
                    red <= 1'b1;
                    yellow <= 1'b0;
                    green <= 1'b0;
                end

                s1_red: begin
                    red <= 1'b1;
                    yellow <= 1'b0;
                    green <= 1'b0;

                    if (cnt == 0) begin
                        state <= s3_green;
                        cnt <= 8'd60;
                        red <= 1'b0;
                        green <= 1'b1;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end

                s2_yellow: begin
                    red <= 1'b0;
                    yellow <= 1'b1;
                    green <= 1'b0;

                    if (cnt == 0) begin
                        state <= s1_red;
                        cnt <= 8'd10;
                        red <= 1'b1;
                        yellow <= 1'b0;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end

                s3_green: begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b1;

                    // Check pedestrian request to shorten green time if >10
                    if (pass_request && (cnt > 8'd10)) begin
                        cnt <= 8'd10;
                    end else if (cnt == 0) begin
                        state <= s2_yellow;
                        cnt <= 8'd5;
                        yellow <= 1'b1;
                        green <= 1'b0;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
            endcase
        end
    end

    assign clock = cnt;

endmodule