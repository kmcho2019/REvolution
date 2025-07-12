module TopModule (
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

always @(*) begin
    case (state)
        2'b00: // State A
            begin
                if (!in) begin
                    next_state = 2'b00;
                    out = 0;
                end else begin
                    next_state = 2'b01;
                    out = 0;
                end
            end
        2'b01: // State B
            begin
                if (!in) begin
                    next_state = 2'b10;
                    out = 0;
                end else begin
                    next_state = 2'b01;
                    out = 0;
                end
            end
        2'b10: // State C
            begin
                if (!in) begin
                    next_state = 2'b00;
                    out = 0;
                end else begin
                    next_state = 2'b11;
                    out = 0;
                end
            end
        2'b11: // State D
            begin
                if (!in) begin
                    next_state = 2'b10;
                    out = 1;
                end else begin
                    next_state = 2'b01;
                    out = 1;
                end
            end
        default:
            begin
                next_state = 2'b00;
                out = 0;
            end
    endcase
end

endmodule