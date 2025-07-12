module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State is represented as a 2-bit counter
    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;  // Reset to state A
        end else begin
            case (state)
                2'b00: state <= in ? 2'b01 : 2'b00;  // A: 0->A, 1->B (increment)
                2'b01: state <= in ? 2'b01 : 2'b10;  // B: 0->C (increment), 1->B (hold)
                2'b10: state <= in ? 2'b11 : 2'b00;  // C: 0->A (reset), 1->D (increment)
                2'b11: state <= in ? 2'b01 : 2'b10;  // D: 0->C (decrement), 1->B (decrement)
            endcase
        end
    end

    // Output is high only in state D (11)
    assign out = state[1] & state[0];

endmodule