module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // 4-bit shift register for one-hot state representation
    // A = 0001, B = 0010, C = 0100, D = 1000
    reg [3:0] state;

    // Next state logic implemented as controlled shifts/sets
    always @(posedge clk) begin
        if (reset) begin
            state <= 4'b0001;  // Reset to state A (LSB set)
        end
        else begin
            case (1'b1)  // Synthesis will optimize this to parallel case
                state[0]: state <= in ? 4'b0010 : 4'b0001;  // A -> B or stay A
                state[1]: state <= in ? 4'b0010 : 4'b0100;  // B -> B or C
                state[2]: state <= in ? 4'b1000 : 4'b0001;  // C -> D or A
                state[3]: state <= in ? 4'b0010 : 4'b0100;  // D -> B or C
            endcase
        end
    end

    // Output is directly the MSB (state D)
    assign out = state[3];

endmodule