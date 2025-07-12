module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output reg       out
);
    always @(*) begin
        // Default outputs
        next_state = 4'b0000;
        out = 1'b0;

        case (state)
            4'b0001: begin // State A
                out = 1'b0;
                next_state = in ? 4'b0010 : 4'b0001; // B if in=1, else A
            end
            4'b0010: begin // State B
                out = 1'b0;
                next_state = in ? 4'b0010 : 4'b0100; // B if in=1, else C
            end
            4'b0100: begin // State C
                out = 1'b0;
                next_state = in ? 4'b1000 : 4'b0001; // D if in=1, else A
            end
            4'b1000: begin // State D
                out = 1'b1;
                next_state = in ? 4'b0010 : 4'b0100; // B if in=1, else C
            end
            default: begin
                // Default fallback: stay in A with output 0
                out = 1'b0;
                next_state = 4'b0001;
            end
        endcase
    end

endmodule