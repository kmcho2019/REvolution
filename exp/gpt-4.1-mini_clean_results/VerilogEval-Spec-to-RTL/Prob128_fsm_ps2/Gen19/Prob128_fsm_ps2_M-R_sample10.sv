module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    state_t state, next_state;
    logic done_reg;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic and done generation
    always @(*) begin
        done_reg = 1'b0;
        case(state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end

            BYTE2: begin
                next_state = BYTE3;
            end

            BYTE3: begin
                done_reg = 1'b1; // done asserted after third byte
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    assign done = done_reg;

endmodule