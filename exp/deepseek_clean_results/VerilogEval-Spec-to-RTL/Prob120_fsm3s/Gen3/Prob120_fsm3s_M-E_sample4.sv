module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot encoded state register (A=0001, B=0010, C=0100, D=1000)
    reg [3:0] state_shiftreg;

    // State transition logic using shift operations with conditional parallel load
    always @(posedge clk) begin
        if (reset) begin
            state_shiftreg <= 4'b0001;  // Reset to state A
        end else begin
            case (1'b1)  // Synthesis will optimize this to parallel logic
                state_shiftreg[0]:  // State A
                    state_shiftreg <= in ? 4'b0010 : 4'b0001;
                state_shiftreg[1]:  // State B
                    state_shiftreg <= in ? 4'b0010 : 4'b0100;
                state_shiftreg[2]:  // State C
                    state_shiftreg <= in ? 4'b1000 : 4'b0001;
                state_shiftreg[3]:  // State D
                    state_shiftreg <= in ? 4'b0010 : 4'b0100;
                default:  // Should never happen
                    state_shiftreg <= 4'b0001;
            endcase
        end
    end

    // Output is high only when in state D (MSB set)
    assign out = state_shiftreg[3];

endmodule