module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State representation: Each bit represents a state (bit0=A, bit1=B, bit2=C, bit3=D)
    reg [3:0] state;

    // Output is directly the D state bit
    assign out = state[3];

    always @(posedge clk) begin
        if (reset) begin
            state <= 4'b0001;  // Reset to state A (bit0 set)
        end else begin
            case (1'b1)  // Find which state bit is set
                state[0]: state <= in ? 4'b0010 : 4'b0001;  // A -> B or A
                state[1]: state <= in ? 4'b0010 : 4'b0100;  // B -> B or C
                state[2]: state <= in ? 4'b1000 : 4'b0001;  // C -> D or A
                state[3]: state <= in ? 4'b0010 : 4'b0100;  // D -> B or C
                default:  state <= 4'b0001;  // Fallback to state A
            endcase
        end
    end

endmodule