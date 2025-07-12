module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding (A=00, B=01, C=10, D=11)
    reg [1:0] state, next_state;
    reg clk_en;

    // Next state logic using case statement
    always @(*) begin
        case (state)
            2'b00: next_state = in ? 2'b01 : 2'b00;  // A -> B or A
            2'b01: next_state = in ? 2'b01 : 2'b10;  // B -> B or C
            2'b10: next_state = in ? 2'b11 : 2'b00;  // C -> D or A
            2'b11: next_state = in ? 2'b01 : 2'b10;  // D -> B or C
            default: next_state = 2'b00;             // Default to A
        endcase
    end

    // Clock gating logic - only enable clock when state will change
    always @(*) begin
        clk_en = (state != next_state);
    end

    // State register update with clock gating
    always @(posedge clk) begin
        if (reset)
            state <= 2'b00;  // Reset to state A
        else if (clk_en)
            state <= next_state;
    end

    // Output logic - only high in state D (11)
    assign out = (state == 2'b11);

endmodule