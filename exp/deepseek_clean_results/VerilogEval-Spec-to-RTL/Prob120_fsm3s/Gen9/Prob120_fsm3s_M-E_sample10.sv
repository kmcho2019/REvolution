module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Shift register states: [D, C, B, A]
    reg [3:0] state;

    // Next state logic - simple shift operations
    always @(posedge clk) begin
        if (reset)
            state <= 4'b0001; // Reset to state A (LSB)
        else begin
            case (state)
                4'b0001: state <= in ? 4'b0010 : 4'b0001; // A -> B or A
                4'b0010: state <= in ? 4'b0010 : 4'b0100; // B -> B or C
                4'b0100: state <= in ? 4'b1000 : 4'b0001; // C -> D or A
                4'b1000: state <= in ? 4'b0010 : 4'b0100; // D -> B or C
                default: state <= 4'b0001; // Should never happen
            endcase
        end
    end

    // Output is simply the MSB (state D)
    assign out = state[3];

endmodule