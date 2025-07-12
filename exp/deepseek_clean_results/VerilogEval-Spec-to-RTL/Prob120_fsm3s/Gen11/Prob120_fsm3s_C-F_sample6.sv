module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding (A=00, B=01, C=11, D=10) - Gray-like encoding
    // Modified to make adjacent states differ by only 1 bit
    reg [1:0] state, next_state;

    // Next state logic with optimized transitions
    always @(*) begin
        case (state)
            2'b00: next_state = in ? 2'b01 : 2'b00;  // A -> B or A
            2'b01: next_state = in ? 2'b01 : 2'b11;  // B -> B or C
            2'b11: next_state = in ? 2'b10 : 2'b00;  // C -> D or A
            2'b10: next_state = in ? 2'b01 : 2'b11;  // D -> B or C
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 2'b00;  // Reset to state A
        else
            state <= next_state;
    end

    // Optimized output logic - only high in state D (10)
    assign out = state[1] & ~state[0];

endmodule