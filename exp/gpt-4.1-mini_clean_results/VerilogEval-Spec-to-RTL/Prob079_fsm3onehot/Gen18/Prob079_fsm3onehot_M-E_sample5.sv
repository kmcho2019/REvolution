module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output       out
);

    always @(*) begin
        case (state)
            4'b0001: // A
                next_state = in ? 4'b0010 : 4'b0001; // B or A
            4'b0010: // B
                next_state = in ? 4'b0010 : 4'b0100; // B or C
            4'b0100: // C
                next_state = in ? 4'b1000 : 4'b0001; // D or A
            4'b1000: // D
                next_state = in ? 4'b0010 : 4'b0100; // B or C
            default:
                next_state = 4'b0001; // Default to A on invalid state
        endcase
    end

    // Output logic: out=1 only in state D
    assign out = (state == 4'b1000);

endmodule