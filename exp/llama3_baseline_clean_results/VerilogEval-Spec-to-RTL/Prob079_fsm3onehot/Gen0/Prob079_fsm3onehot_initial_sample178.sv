module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

always @(*) begin
    case (state)
        4'b0001: // State A
            if (!in) begin
                next_state = 4'b0001; // Stay in A
                out = 0;
            end else begin
                next_state = 4'b0010; // Go to B
                out = 0;
            end
        4'b0010: // State B
            if (!in) begin
                next_state = 4'b0100; // Go to C
                out = 0;
            end else begin
                next_state = 4'b0010; // Stay in B
                out = 0;
            end
        4'b0100: // State C
            if (!in) begin
                next_state = 4'b0001; // Go to A
                out = 0;
            end else begin
                next_state = 4'b1000; // Go to D
                out = 0;
            end
        4'b1000: // State D
            if (!in) begin
                next_state = 4'b0100; // Go to C
                out = 1;
            end else begin
                next_state = 4'b0010; // Go to B
                out = 1;
            end
        default: begin
            next_state = 4'bxxxx; // Don't care
            out = 1'bx; // Don't care
        end
    endcase
end

endmodule