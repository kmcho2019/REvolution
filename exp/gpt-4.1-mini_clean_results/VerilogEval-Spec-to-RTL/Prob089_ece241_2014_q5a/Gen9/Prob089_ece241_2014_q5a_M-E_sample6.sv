module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE  = 2'b00, // After reset, output 0
        PASS  = 2'b01, // Passing input bits as is
        INVERT= 2'b10  // Invert bits after first '1'
    } state_t;

    state_t state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            IDLE: begin
                // After reset release, go to PASS to start processing input
                next_state = PASS;
            end
            PASS: begin
                // Wait until first 1 bit to move to INVERT
                if (x == 1'b1)
                    next_state = INVERT;
                else
                    next_state = PASS;
            end
            INVERT: begin
                // Stay in INVERT forever until reset
                next_state = INVERT;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic (Moore output depends only on state and input x, which is available and stable)
    always @(*) begin
        case(state)
            IDLE:   z = 1'b0;
            PASS:   z = x;       // Pass input bits as is
            INVERT: z = ~x;      // Invert bits after first '1'
            default:z = 1'b0;
        endcase
    end

endmodule