module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // Define states
    typedef enum logic [1:0] {
        WAIT_FOR_START = 2'b00, // Waiting for the first '1' bit
        PASS_THROUGH  = 2'b01,  // Output the first '1' bit as is
        INVERT_BITS   = 2'b10   // Output the inverted bits (2's complement tail)
    } state_t;

    state_t state, next_state;
    reg x_reg;        // Registered input bit to align with FSM and output timing
    reg out_bit;      // Output bit registered (Moore output)

    // Register input x synchronously with clock and async reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            x_reg <= 1'b0;
        else
            x_reg <= x;
    end

    // FSM state register with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= WAIT_FOR_START;
        else
            state <= next_state;
    end

    // Next state logic combinational
    always_comb begin
        unique case (state)
            WAIT_FOR_START: begin
                // Remain here until a '1' bit arrives
                if (x_reg == 1'b1)
                    next_state = PASS_THROUGH;
                else
                    next_state = WAIT_FOR_START;
            end

            PASS_THROUGH: begin
                // After outputting the first '1' bit, transition to invert state
                next_state = INVERT_BITS;
            end

            INVERT_BITS: begin
                // Stay here indefinitely, inverting bits
                next_state = INVERT_BITS;
            end

            default: next_state = WAIT_FOR_START;
        endcase
    end

    // Moore output logic (registered output z)
    // Depends only on current state and registered input bit x_reg
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            out_bit <= 1'b0;
        else begin
            unique case (state)
                WAIT_FOR_START: out_bit <= 1'b0;        // Output zeros while waiting
                PASS_THROUGH:  out_bit <= x_reg;        // Output first '1' bit as is
                INVERT_BITS:   out_bit <= ~x_reg;       // Output inverted bits after first '1'
                default:       out_bit <= 1'b0;
            endcase
        end
    end

    // Assign registered output
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            z <= 1'b0;
        else
            z <= out_bit;
    end

endmodule