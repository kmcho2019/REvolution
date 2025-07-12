module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output       out
);

    always @(*) begin
        casez (state)
            4'b0001: // State A
                next_state = in ? 4'b0010 : 4'b0001; // B if in=1 else A
            4'b0010: // State B
                next_state = in ? 4'b0010 : 4'b0100; // B if in=1 else C
            4'b0100: // State C
                next_state = in ? 4'b1000 : 4'b0001; // D if in=1 else A
            4'b1000: // State D
                next_state = in ? 4'b0010 : 4'b0100; // B if in=1 else C
            default:
                next_state = 4'b0000; // Invalid state safety
        endcase
    end

    // Output high only in state D
    assign out = (state == 4'b1000);

endmodule