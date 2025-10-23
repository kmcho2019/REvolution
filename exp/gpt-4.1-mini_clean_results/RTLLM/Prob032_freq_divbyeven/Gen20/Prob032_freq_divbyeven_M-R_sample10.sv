module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time check for even NUM_DIV
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("Error: NUM_DIV parameter must be even. Given: %0d", NUM_DIV);
        end
    end

    localparam integer HALF_DIV = NUM_DIV >> 1;

    // States of the FSM represent clk_div output level
    typedef enum logic [0:0] {
        LOW  = 1'b0,
        HIGH = 1'b1
    } state_t;

    state_t state, next_state;

    reg [3:0] cnt;  // 4-bit counter as specified

    // Next-state logic and output control
    always @(*) begin
        next_state = state;
        case (state)
            LOW: begin
                if (cnt == HALF_DIV - 1)
                    next_state = HIGH;
            end
            HIGH: begin
                if (cnt == HALF_DIV - 1)
                    next_state = LOW;
            end
        endcase
    end

    // Sequential logic: state and counter update, output update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state   <= LOW;
            cnt     <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == HALF_DIV - 1) begin
                cnt <= 0;
                state <= next_state;
                clk_div <= next_state;  // clk_div follows state
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule