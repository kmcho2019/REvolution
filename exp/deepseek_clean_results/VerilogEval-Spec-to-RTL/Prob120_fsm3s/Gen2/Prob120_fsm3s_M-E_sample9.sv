module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state representation (A=0001, B=0010, C=0100, D=1000)
    reg [3:0] state_shift;

    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 4'b0001;  // Reset to state A
        end else begin
            case (state_shift)
                4'b0001: state_shift <= in ? 4'b0010 : 4'b0001;  // A -> B if in=1, else stay
                4'b0010: state_shift <= in ? 4'b0010 : 4'b0100;  // B -> C if in=0, else stay
                4'b0100: state_shift <= in ? 4'b1000 : 4'b0001;  // C -> D if in=1, else A
                4'b1000: state_shift <= in ? 4'b0010 : 4'b0100;  // D -> B if in=1, else C
                default: state_shift <= 4'b0001;  // Handle invalid states
            endcase
        end
    end

    // Output is high when in state D (MSB set)
    assign out = state_shift[3];

endmodule