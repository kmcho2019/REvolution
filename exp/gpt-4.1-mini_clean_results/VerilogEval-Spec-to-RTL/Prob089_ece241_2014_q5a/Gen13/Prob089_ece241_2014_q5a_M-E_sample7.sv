module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding:
    // We store the output bit 'z' in the state register along with FSM status
    // State bits: {fsm_state, output_bit}
    // fsm_state: 0 = waiting for first 1 (carry not started)
    //            1 = inverting subsequent bits (carry started)
    // output_bit: bit to output on current cycle
    reg [1:0] state, next_state;

    // State fields for clarity
    wire fsm_state = state[1];    // FSM status
    wire out_bit   = state[0];    // output bit stored

    always @(posedge clk or posedge areset) begin
        if (areset)
            // Reset to waiting state, output zero
            state <= 2'b00;
        else
            state <= next_state;
    end

    always @(*) begin
        // Default next state same as current to avoid latches
        next_state = state;

        case (fsm_state)
            1'b0: begin
                // Waiting for first '1'
                if (x == 1'b1) begin
                    // On seeing first 1: output 1 and move to inverting state
                    next_state = {1'b1, 1'b1};
                end else begin
                    // Still waiting, output input bit as is (0)
                    next_state = {1'b0, x};
                end
            end
            1'b1: begin
                // After first 1, invert input bits for 2's complement
                // Output inverted input bit
                next_state = {1'b1, ~x};
            end
            default: next_state = 2'b00; // safe default
        endcase
    end

    // Output stored in state register (Moore output)
    always @(posedge clk or posedge areset) begin
        if (areset)
            z <= 1'b0;
        else
            z <= state[0];
    end

endmodule