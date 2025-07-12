module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output reg   red,
    output reg   yellow,
    output reg   green
);

    localparam IDLE   = 2'd0;
    localparam RED_S  = 2'd1;
    localparam GREEN_S= 2'd2;
    localparam YELLOW_S=2'd3;

    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_SHORT = 8'd10;

    reg [7:0] cnt;
    reg [1:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 8'd0;
            red <= 0; yellow <= 0; green <= 0;
            clock <= 8'd0;
        end else begin
            case(state)
                IDLE: begin
                    // Immediately go to RED state
                    state <= RED_S;
                    cnt <= RED_TIME;
                    red <= 1; yellow <= 0; green <= 0;
                    clock <= RED_TIME;
                end
                RED_S: begin
                    if (cnt == 0) begin
                        state <= GREEN_S;
                        cnt <= GREEN_TIME;
                        red <= 0; yellow <= 0; green <= 1;
                        clock <= GREEN_TIME;
                    end else begin
                        cnt <= cnt - 1;
                        clock <= cnt - 1;
                    end
                end
                GREEN_S: begin
                    if (pass_request && (cnt > GREEN_SHORT)) begin
                        cnt <= GREEN_SHORT;
                        clock <= GREEN_SHORT;
                    end else if (cnt == 0) begin
                        state <= YELLOW_S;
                        cnt <= YELLOW_TIME;
                        red <= 0; yellow <= 1; green <= 0;
                        clock <= YELLOW_TIME;
                    end else begin
                        cnt <= cnt - 1;
                        clock <= cnt - 1;
                    end
                end
                YELLOW_S: begin
                    if (cnt == 0) begin
                        state <= RED_S;
                        cnt <= RED_TIME;
                        red <= 1; yellow <= 0; green <= 0;
                        clock <= RED_TIME;
                    end else begin
                        cnt <= cnt - 1;
                        clock <= cnt - 1;
                    end
                end
                default: begin
                    state <= IDLE;
                    cnt <= 8'd0;
                    red <= 0; yellow <= 0; green <= 0;
                    clock <= 8'd0;
                end
            endcase
        end
    end

endmodule