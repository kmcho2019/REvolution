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
    localparam IDLE    = 2'd0; // Not used except at reset
    localparam RED     = 2'd1;
    localparam YELLOW  = 2'd2;
    localparam GREEN   = 2'd3;

    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam SHORT_GREEN = 8'd10;

    reg [1:0] state;
    reg [7:0] timer;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= RED;
            timer <= RED_TIME;
        end else begin
            case (state)
                RED: begin
                    if (timer == 0) begin
                        state <= GREEN;
                        timer <= GREEN_TIME;
                    end else begin
                        timer <= timer - 1;
                    end
                end
                GREEN: begin
                    if (pass_request && (timer > SHORT_GREEN))
                        timer <= SHORT_GREEN;
                    else if (timer == 0) begin
                        state <= YELLOW;
                        timer <= YELLOW_TIME;
                    end else begin
                        timer <= timer - 1;
                    end
                end
                YELLOW: begin
                    if (timer == 0) begin
                        state <= RED;
                        timer <= RED_TIME;
                    end else begin
                        timer <= timer - 1;
                    end
                end
                default: begin
                    state <= RED;
                    timer <= RED_TIME;
                end
            endcase
        end
    end

    // Output logic
    always @(*) begin
        red    = (state == RED);
        yellow = (state == YELLOW);
        green  = (state == GREEN);
        clock  = timer;
    end

endmodule