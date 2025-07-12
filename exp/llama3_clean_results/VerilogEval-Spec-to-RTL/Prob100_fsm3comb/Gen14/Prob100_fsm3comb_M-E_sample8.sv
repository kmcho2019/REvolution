module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

    reg [1:0] next_state_reg;
    reg out_reg;

    always @(*) begin
        case ({state, in})
            3'b0000: begin next_state_reg = 2'b00; out_reg = 1'b0; end
            3'b0001: begin next_state_reg = 2'b01; out_reg = 1'b0; end
            3'b0100: begin next_state_reg = 2'b10; out_reg = 1'b0; end
            3'b0101: begin next_state_reg = 2'b01; out_reg = 1'b0; end
            3'b1000: begin next_state_reg = 2'b00; out_reg = 1'b0; end
            3'b1001: begin next_state_reg = 2'b11; out_reg = 1'b0; end
            3'b1100: begin next_state_reg = 2'b10; out_reg = 1'b1; end
            3'b1101: begin next_state_reg = 2'b01; out_reg = 1'b1; end
            default: begin next_state_reg = 2'b00; out_reg = 1'b0; end
        endcase
    end

    assign next_state = next_state_reg;
    assign out = out_reg;

endmodule