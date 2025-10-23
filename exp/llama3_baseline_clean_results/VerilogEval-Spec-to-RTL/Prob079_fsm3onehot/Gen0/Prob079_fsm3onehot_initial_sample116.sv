module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

always @(*) begin
    case (state)
        4'b0001: // State A
            begin
                if (!in) next_state = 4'b0001; // Next state A if in=0
                else next_state = 4'b0010; // Next state B if in=1
                out = 1'b0;
            end
        4'b0010: // State B
            begin
                if (!in) next_state = 4'b0100; // Next state C if in=0
                else next_state = 4'b0010; // Next state B if in=1
                out = 1'b0;
            end
        4'b0100: // State C
            begin
                if (!in) next_state = 4'b0001; // Next state A if in=0
                else next_state = 4'b1000; // Next state D if in=1
                out = 1'b0;
            end
        4'b1000: // State D
            begin
                if (!in) next_state = 4'b0100; // Next state C if in=0
                else next_state = 4'b0010; // Next state B if in=1
                out = 1'b1;
            end
        default: // Default state (should not occur with one-hot encoding)
            begin
                next_state = 4'b0001; // Reset to state A
                out = 1'b0;
            end
    endcase
end

endmodule