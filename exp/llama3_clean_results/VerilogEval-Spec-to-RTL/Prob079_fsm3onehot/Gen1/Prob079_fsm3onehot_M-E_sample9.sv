module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

// Next state and output logic using case statement
always @(*) begin
    case (state)
        4'b0001: // State A
            if (!in) begin
                next_state = 4'b0001; // A -> A when in=0
                out = 1'b0;
            end else begin
                next_state = 4'b0010; // A -> B when in=1
                out = 1'b0;
            end
        4'b0010: // State B
            if (!in) begin
                next_state = 4'b0100; // B -> C when in=0
                out = 1'b0;
            end else begin
                next_state = 4'b0010; // B -> B when in=1
                out = 1'b0;
            end
        4'b0100: // State C
            if (!in) begin
                next_state = 4'b0001; // C -> A when in=0
                out = 1'b0;
            end else begin
                next_state = 4'b1000; // C -> D when in=1
                out = 1'b0;
            end
        4'b1000: // State D
            if (!in) begin
                next_state = 4'b0100; // D -> C when in=0
                out = 1'b1;
            end else begin
                next_state = 4'b0010; // D -> B when in=1
                out = 1'b1;
            end
        default: begin
            next_state = 4'b0000; // default state
            out = 1'b0;
        end
    endcase
end

endmodule