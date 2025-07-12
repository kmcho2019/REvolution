module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Optimized state encoding (A=00, B=01, D=11, C=10)
    // Gray-like ordering to minimize transitions between B<->D (frequent)
    reg [1:0] state, next_state;

    // Next state logic with optimized encoding
    always @(*) begin
        case (state)
            2'b00: next_state = in ? 2'b01 : 2'b00;  // A -> B or A
            2'b01: next_state = in ? 2'b01 : 2'b10;  // B -> B or C
            2'b10: next_state = in ? 2'b11 : 2'b00;  // C -> D or A
            2'b11: next_state = in ? 2'b01 : 2'b10;  // D -> B or C
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 2'b00;  // Reset to state A
        else
            state <= next_state;
    end

    // Optimized output logic - only high in state D (11)
    assign out = (state == 2'b11);  // Clearer than bitwise AND while equally efficient

endmodule