module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);
    // One-hot encoded states: A = 2'b01, B = 2'b10
    reg [1:0] state, next_state;

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;    // Reset to state A
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    // From state A: if x=0 stay in A; if x=1 go to B
    // From state B: always stay in B
    always @(*) begin
        case (state)
            2'b01: next_state = x ? 2'b10 : 2'b01; // A state
            2'b10: next_state = 2'b10;              // B state
            default: next_state = 2'b01;            // Default safety
        endcase
    end

    // Mealy output logic as combinational assign statement
    // z = 1 when (state A and x=1) or (state B and x=0)
    assign z = (state[0] & x) | (state[1] & ~x);

endmodule