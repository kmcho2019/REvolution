module TopModule(
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

always @(state, in) begin
    case (state)
        2'b00: begin // State A
            next_state = in ? 2'b01 : 2'b00;
            out = 1'b0;
        end
        2'b01: begin // State B
            next_state = in ? 2'b01 : 2'b10;
            out = 1'b0;
        end
        2'b10: begin // State C
            next_state = in ? 2'b11 : 2'b00;
            out = 1'b0;
        end
        2'b11: begin // State D
            next_state = in ? 2'b01 : 2'b10;
            out = 1'b1;
        end
    endcase
end

endmodule