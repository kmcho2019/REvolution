module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output reg out
);

always @(*) begin
    // Default assignments
    next_state = 4'b0000;
    out = 1'b0;

    // State transition logic
    case (1'b1)
        state[0]: begin // State A (0001)
            next_state = in ? 4'b0010 : 4'b0001; // B or A
        end
        state[1]: begin // State B (0010)
            next_state = in ? 4'b0010 : 4'b0100; // B or C
        end
        state[2]: begin // State C (0100)
            next_state = in ? 4'b1000 : 4'b0001; // D or A
        end
        state[3]: begin // State D (1000)
            next_state = in ? 4'b0010 : 4'b0100; // B or C
            out = 1'b1; // Output is 1 in state D
        end
        default: next_state = 4'b0001; // Default to state A
    endcase
end

endmodule