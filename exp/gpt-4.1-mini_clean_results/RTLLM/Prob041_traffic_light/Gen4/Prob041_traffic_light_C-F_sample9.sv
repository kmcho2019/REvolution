module traffic_light (
    input           rst_n,
    input           clk,
    input           pass_request,
    output  [7:0]   clock,
    output reg      red,
    output reg      yellow,
    output reg      green
);

    // Timing parameters
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_SHORT = 8'd10;

    // State encoding
    typedef enum reg [1:0] {
        IDLE    = 2'd0,
        RED     = 2'd1,
        GREEN   = 2'd2,
        YELLOW  = 2'd3
    } state_t;

    reg [7:0] cnt;
    state_t state;

    // Sequential logic: state machine and counter updates
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt   <= 8'd10;  // Default start count for IDLE
        end else begin
            case (state)
                IDLE: begin
                    // Transition immediately to RED state with RED_TIME
                    state <= RED;
                    cnt   <= RED_TIME;
                end

                RED: begin
                    if (cnt == 0) begin
                        state <= GREEN;
                        cnt   <= GREEN_TIME;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end

                GREEN: begin
                    if (cnt == 0) begin
                        state <= YELLOW;
                        cnt   <= YELLOW_TIME;
                    end else if (pass_request && (cnt > GREEN_SHORT)) begin
                        cnt <= GREEN_SHORT;  // Shorten green duration on request
                    end else begin
                        cnt <= cnt - 1;
                    end
                end

                YELLOW: begin
                    if (cnt == 0) begin
                        state <= RED;
                        cnt   <= RED_TIME;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end

                default: begin
                    // Fallback to RED state
                    state <= RED;
                    cnt   <= RED_TIME;
                end
            endcase
        end
    end

    // Output logic: synchronous registered outputs driven by state
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
        end else begin
            red    <= (state == RED);
            yellow <= (state == YELLOW);
            green  <= (state == GREEN);
        end
    end

    // Assign counter value to output
    assign clock = cnt;

endmodule