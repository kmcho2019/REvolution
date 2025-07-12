module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Shift register states (one-hot)
    // Order: A, B, C, D, E, F
    reg [5:0] state;

    // Output is high for states E (bit 4) and F (bit 5)
    assign z = state[4] | state[5];

    always @(posedge clk) begin
        if (reset) begin
            state <= 6'b100000; // Reset to state A
        end else begin
            case (1'b1) // Synthesis will optimize this to priority encoder
                state[0]: state <= w ? 6'b100000 : 6'b010000; // A transitions
                state[1]: state <= w ? 6'b000100 : 6'b001000; // B transitions
                state[2]: state <= w ? 6'b000100 : 6'b001100; // C transitions
                state[3]: state <= w ? 6'b100000 : 6'b000010; // D transitions
                state[4]: state <= w ? 6'b000100 : 6'b001100; // E transitions
                state[5]: state <= w ? 6'b000100 : 6'b001000; // F transitions
                default:   state <= 6'b100000; // Fault recovery
            endcase
        end
    end

endmodule