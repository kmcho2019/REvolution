module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg [7:0]  clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

    // State encoding
    localparam IDLE   = 2'd0;
    localparam RED    = 2'd1;
    localparam GREEN  = 2'd2;
    localparam YELLOW = 2'd3;

    // Timing parameters
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam SHORT_GREEN = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] timer;
    reg       green_shortened; // Flag to avoid multiple green shortenings

    // Synchronous state and timer management
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= IDLE;
            timer          <= 8'd0;
            clock          <= 8'd0;
            red            <= 1'b0;
            yellow         <= 1'b0;
            green          <= 1'b0;
            green_shortened<= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    // Immediately transition to RED with timer preload
                    state          <= RED;
                    timer          <= RED_TIME - 1;
                    red            <= 1'b1;
                    yellow         <= 1'b0;
                    green          <= 1'b0;
                    green_shortened<= 1'b0;
                    clock          <= RED_TIME - 1;
                end

                RED: begin
                    red    <= 1'b1;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                    if (timer == 0) begin
                        state          <= GREEN;
                        timer          <= GREEN_TIME - 1;
                        green_shortened<= 1'b0;
                        clock          <= GREEN_TIME - 1;
                        red            <= 1'b0;
                        green          <= 1'b1;
                    end else begin
                        timer  <= timer - 1;
                        clock  <= timer - 1;
                    end
                end

                GREEN: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b1;
                    // Handle pass_request once per green cycle
                    if (pass_request && !green_shortened && timer > (SHORT_GREEN - 1)) begin
                        timer          <= SHORT_GREEN - 1; // Set to 9 counts left = 10 clocks
                        clock          <= SHORT_GREEN - 1;
                        green_shortened<= 1'b1;
                    end else if (timer == 0) begin
                        state          <= YELLOW;
                        timer          <= YELLOW_TIME - 1;
                        clock          <= YELLOW_TIME - 1;
                        green          <= 1'b0;
                        yellow         <= 1'b1;
                    end else begin
                        timer          <= timer - 1;
                        clock          <= timer - 1;
                    end
                end

                YELLOW: begin
                    red    <= 1'b0;
                    yellow <= 1'b1;
                    green  <= 1'b0;
                    if (timer == 0) begin
                        state          <= RED;
                        timer          <= RED_TIME - 1;
                        clock          <= RED_TIME - 1;
                        yellow         <= 1'b0;
                        red            <= 1'b1;
                    end else begin
                        timer          <= timer - 1;
                        clock          <= timer - 1;
                    end
                end

                default: begin
                    // Defensive reset state
                    state          <= IDLE;
                    timer          <= 8'd0;
                    clock          <= 8'd0;
                    red            <= 1'b0;
                    yellow         <= 1'b0;
                    green          <= 1'b0;
                    green_shortened<= 1'b0;
                end
            endcase
        end
    end

endmodule