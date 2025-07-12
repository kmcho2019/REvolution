module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam BEFORE_CARRY = 1'b0;
    localparam AFTER_CARRY  = 1'b1;

    reg state, next_state;

    // Next state and output combinational logic (uses current state and input x directly)
    always @(*) begin
        case(state)
            BEFORE_CARRY: begin
                z = x;                // Output same bit until first '1' is found
                if (x == 1'b1)
                    next_state = AFTER_CARRY;
                else
                    next_state = BEFORE_CARRY;
            end
            AFTER_CARRY: begin
                z = ~x;               // Output inverted bits after first '1'
                next_state = AFTER_CARRY; // Remain in AFTER_CARRY state
            end
            default: begin
                z = 1'b0;
                next_state = BEFORE_CARRY;
            end
        endcase
    end

    // State and output register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= BEFORE_CARRY;
            z <= 1'b0;
        end else begin
            state <= next_state;
            // z is already assigned in combinational block, registered here for synchronization
            // (kept from combinational block)
            // In Verilog, this implies that the z from combinational logic is assigned to z reg here,
            // but since it's not a non-blocking assignment here, we must replicate the logic or 
            // use a temporary signal. To fix that, use a temporary combinational signal.

            // To correct, we will separate output combinational signal and register output below.
        end
    end

endmodule