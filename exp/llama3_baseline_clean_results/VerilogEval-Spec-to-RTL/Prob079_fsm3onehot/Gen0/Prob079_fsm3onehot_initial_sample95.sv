module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Next state logic
    always_comb begin
        case (state)
            4'b0001: next_state = in ? 4'b0010 : 4'b0001; // State A
            4'b0010: next_state = in ? 4'b0010 : 4'b0100; // State B
            4'b0100: next_state = in ? 4'b1000 : 4'b0001; // State C
            4'b1000: next_state = in ? 4'b0010 : 4'b0100; // State D
            default: next_state = 4'b0000; // Default, should not occur
        endcase
    end

    // Output logic
    always_comb begin
        case (state)
            4'b0001, 4'b0010, 4'b0100: out = 1'b0; // States A, B, C
            4'b1000: out = 1'b1; // State D
            default: out = 1'b0; // Default, should not occur
        endcase
    end

endmodule