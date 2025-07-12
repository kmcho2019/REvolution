module freq_diveven #
(
    parameter NUM_DIV = 6  // Must be even
)
(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Check parameter evenness at elaboration
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("Parameter NUM_DIV must be even. Current value: %d", NUM_DIV);
            $finish;
        end
    end

    // Calculate half count value (NUM_DIV/2 - 1)
    localparam HALF = (NUM_DIV >> 1) - 1;
    localparam CNT_WIDTH = $clog2(HALF+1);

    // FSM states for clk_div output
    typedef enum logic {LOW=1'b0, HIGH=1'b1} clk_div_state_t;

    reg [CNT_WIDTH-1:0] cnt;
    reg clk_div_reg;
    clk_div_state_t state, next_state;

    // Next state logic: toggle state when count reaches HALF
    always @(*) begin
        if (cnt == HALF) begin
            next_state = (state == LOW) ? HIGH : LOW;
        end else begin
            next_state = state;
        end
    end

    // Counter increment and state update on posedge clk with synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 0;
            state     <= LOW;
        end else begin
            if (cnt == HALF) begin
                cnt   <= 0;
                state <= next_state;
            end else begin
                cnt <= cnt + 1;
                state <= state;
            end
        end
    end

    // Assign output clk_div as current state
    assign clk_div = state;

endmodule