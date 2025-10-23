module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

reg [1:0] next_state_reg;
reg out_reg;

always @(in, state) begin
    case (state)
        2'b00: begin // State A
            next_state_reg = in ? 2'b01 : 2'b00;
            out_reg = 1'b0;
        end
        2'b01: begin // State B
            next_state_reg = in ? 2'b01 : 2'b10;
            out_reg = 1'b0;
        end
        2'b10: begin // State C
            next_state_reg = in ? 2'b11 : 2'b00;
            out_reg = 1'b0;
        end
        2'b11: begin // State D
            next_state_reg = in ? 2'b01 : 2'b10;
            out_reg = 1'b1;
        end
    endcase
    next_state = next_state_reg;
    out = out_reg;
end

endmodule