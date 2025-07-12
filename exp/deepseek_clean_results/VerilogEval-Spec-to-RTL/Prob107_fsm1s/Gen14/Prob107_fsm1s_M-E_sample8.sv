module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // 2-bit shift register for state representation
    reg [1:0] state;

    // State transition and reset logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b01;  // Reset to state B (01)
        end else begin
            case (state)
                2'b01: state <= in ? 2'b01 : 2'b10;  // B -> B if in=1, else -> A
                2'b10: state <= in ? 2'b10 : 2'b01;  // A -> A if in=1, else -> B
                default: state <= 2'b01;             // Handle any invalid states
            endcase
        end
    end

    // Output logic - MSB inverted (0 for A, 1 for B)
    assign out = ~state[1];

endmodule