module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot shift register (4 bits for 4 states)
    // A = 0001, B = 0010, C = 0100, D = 1000
    reg [3:0] state_shift;

    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 4'b0001;  // Reset to state A (LSB set)
        end
        else begin
            case (1'b1)  // Synthesis will optimize this to parallel muxes
                state_shift[0]: state_shift <= in ? 4'b0010 : 4'b0001;  // A -> B or A
                state_shift[1]: state_shift <= in ? 4'b0010 : 4'b0100;   // B -> B or C
                state_shift[2]: state_shift <= in ? 4'b1000 : 4'b0001;   // C -> D or A
                state_shift[3]: state_shift <= in ? 4'b0010 : 4'b0100;   // D -> B or C
            endcase
        end
    end

    // Output is high when in state D (MSB set)
    assign out = state_shift[3];

endmodule