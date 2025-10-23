module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding (A=00, B=01, C=10, D=11)
    reg [1:0] state, next_state;

    // Next state logic using case statement
    always @(*) begin
        case (state)
            2'b00: next_state = in ? 2'b01 : 2'b00;  // A -> B or A
            2'b01: next_state = in ? 2'b01 : 2'b10;  // B -> B or C
            2'b10: next_state = in ? 2'b11 : 2'b00;  // C -> D or A
            2'b11: next_state = in ? 2'b01 : 2'b10;  // D -> B or C
        endcase
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= 2'b00;  // Reset to state A
        else
            state <= next_state;
    end

    // Output logic - only high when state is D (11)
    assign out = state[1] & state[0];

endmodule