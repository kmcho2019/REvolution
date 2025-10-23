module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Shift register states: [F E D C B A]
    reg [5:0] state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 6'b000001;  // Reset to state A
        end else begin
            case (1'b1)
                state[0]: state <= w ? 6'b000001 : 6'b000010; // A transitions
                state[1]: state <= w ? 6'b000100 : 6'b000110; // B transitions
                state[2]: state <= w ? 6'b000100 : 6'b001100; // C transitions
                state[3]: state <= w ? 6'b000001 : 6'b010000; // D transitions
                state[4]: state <= w ? 6'b000100 : 6'b001000; // E transitions
                state[5]: state <= w ? 6'b000100 : 6'b000110; // F transitions
                default:  state <= 6'b000001;  // Safety catch
            endcase
        end
    end

    // Output is high when in E or F states (bits 4 or 5 set)
    assign z = |state[5:4];

endmodule