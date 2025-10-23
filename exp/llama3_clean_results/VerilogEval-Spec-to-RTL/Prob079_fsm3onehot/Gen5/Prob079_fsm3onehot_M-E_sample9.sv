module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    reg [3:0] next_state_reg;
    reg out_reg;

    always @(*) begin
        case ({in, state})
            5'b00001: begin next_state_reg = 4'b0001; out_reg = 1'b0; end
            5'b10001: begin next_state_reg = 4'b0010; out_reg = 1'b0; end
            5'b00010: begin next_state_reg = 4'b0100; out_reg = 1'b0; end
            5'b10010: begin next_state_reg = 4'b0010; out_reg = 1'b0; end
            5'b00100: begin next_state_reg = 4'b0001; out_reg = 1'b0; end
            5'b10100: begin next_state_reg = 4'b1000; out_reg = 1'b0; end
            5'b01000: begin next_state_reg = 4'b0100; out_reg = 1'b1; end
            5'b11000: begin next_state_reg = 4'b0010; out_reg = 1'b1; end
            default: begin next_state_reg = 4'bxxxx; out_reg = 1'b0; end
        endcase
    end

    assign next_state = next_state_reg;
    assign out = out_reg;

endmodule