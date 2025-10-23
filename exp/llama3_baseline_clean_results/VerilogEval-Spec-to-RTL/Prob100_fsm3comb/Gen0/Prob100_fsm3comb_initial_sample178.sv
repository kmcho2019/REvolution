module TopModule(
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

    always @(state, in) begin
        case (state)
            2'b00: // State A
                if (!in) begin
                    next_state = 2'b00;
                    out = 0;
                end else begin
                    next_state = 2'b01;
                    out = 0;
                end

            2'b01: // State B
                if (!in) begin
                    next_state = 2'b10;
                    out = 0;
                end else begin
                    next_state = 2'b01;
                    out = 0;
                end

            2'b10: // State C
                if (!in) begin
                    next_state = 2'b00;
                    out = 0;
                end else begin
                    next_state = 2'b11;
                    out = 0;
                end

            2'b11: // State D
                if (!in) begin
                    next_state = 2'b10;
                    out = 1;
                end else begin
                    next_state = 2'b01;
                    out = 1;
                end

            default: begin
                next_state = 2'bx;
                out = 1'bx;
            end
        endcase
    end

endmodule