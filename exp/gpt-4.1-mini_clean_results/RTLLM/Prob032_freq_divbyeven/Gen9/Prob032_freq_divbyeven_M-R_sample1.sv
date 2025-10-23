module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameter check at elaboration time
    initial begin
        if ((NUM_DIV < 2) || (NUM_DIV % 2 != 0)) begin
            $fatal("Error: NUM_DIV parameter must be even and >= 2. Given: %0d", NUM_DIV);
        end
    end

    localparam integer HALF_DIV = NUM_DIV >> 1;
    localparam integer CNT_WIDTH = (HALF_DIV > 1) ? $clog2(HALF_DIV) : 1;

    // State encoding: 1-bit state represents clk_div level
    typedef enum logic [0:0] {
        S_LOW  = 1'b0,
        S_HIGH = 1'b1
    } state_t;

    state_t state, next_state;
    reg [CNT_WIDTH-1:0] cnt, next_cnt;

    // State and counter update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_LOW;
            cnt   <= 0;
        end else begin
            state <= next_state;
            cnt   <= next_cnt;
        end
    end

    // Next state and counter logic
    always @(*) begin
        next_state = state;
        next_cnt = cnt;

        if (cnt == HALF_DIV - 1) begin
            // When counter reaches limit, toggle state and reset counter
            next_state = (state == S_LOW) ? S_HIGH : S_LOW;
            next_cnt = 0;
        end else begin
            next_cnt = cnt + 1;
        end
    end

    // Output clock reflects current FSM state
    assign clk_div = (state == S_HIGH) ? 1'b1 : 1'b0;

endmodule