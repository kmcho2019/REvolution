module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

    always @(*) begin
        case (state)
            2'b00: begin // State A
                out = 1'b0;
                if (!in) next_state = 2'b00;
                else next_state = 2'b01;
            end
            2'b01: begin // State B
                out = 1'b0;
                if (!in) next_state = 2'b10;
                else next_state = 2'b01;
            end
            2'b10: begin // State C
                out = 1'b0;
                if (!in) next_state = 2'b00;
                else next_state = 2'b11;
            end
            2'b11: begin // State D
                out = 1'b1;
                if (!in) next_state = 2'b10;
                else next_state = 2'b01;
            end
            default: begin
                out = 1'bx;
                next_state = 2'bx;
            end
        endcase
    end

endmodule