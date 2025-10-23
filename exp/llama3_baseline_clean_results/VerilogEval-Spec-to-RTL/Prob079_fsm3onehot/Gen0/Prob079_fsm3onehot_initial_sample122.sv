module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    // State transition logic
    always @(*) begin
        case (state)
            4'b0001: // State A
                next_state = in ? 4'b0010 : 4'b0001; // in=1 -> B, in=0 -> A
            4'b0010: // State B
                next_state = in ? 4'b0010 : 4'b0100; // in=1 -> B, in=0 -> C
            4'b0100: // State C
                next_state = in ? 4'b1000 : 4'b0001; // in=1 -> D, in=0 -> A
            4'b1000: // State D
                next_state = in ? 4'b0010 : 4'b0100; // in=1 -> B, in=0 -> C
            default: // Invalid state, default to A
                next_state = 4'b0001;
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            4'b0001, 4'b0010, 4'b0100: // States A, B, C
                out = 1'b0;
            4'b1000: // State D
                out = 1'b1;
            default: // Invalid state, default output to 0
                out = 1'b0;
        endcase
    end

endmodule