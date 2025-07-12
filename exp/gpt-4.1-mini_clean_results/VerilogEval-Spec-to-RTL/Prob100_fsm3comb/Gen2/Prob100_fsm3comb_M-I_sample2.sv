module TopModule(
    input       in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // Declare combinational wires for outputs
    reg [1:0] next_state_reg;
    reg       out_reg;

    // Flattened case on concatenated {state,in}
    always @(*) begin
        case ({state, in})
            3'b000: begin next_state_reg = 2'b00; out_reg = 1'b0; end // A, in=0 -> A, out=0
            3'b001: begin next_state_reg = 2'b01; out_reg = 1'b0; end // A, in=1 -> B, out=0

            3'b010: begin next_state_reg = 2'b10; out_reg = 1'b0; end // B, in=0 -> C, out=0
            3'b011: begin next_state_reg = 2'b01; out_reg = 1'b0; end // B, in=1 -> B, out=0

            3'b100: begin next_state_reg = 2'b00; out_reg = 1'b0; end // C, in=0 -> A, out=0
            3'b101: begin next_state_reg = 2'b11; out_reg = 1'b0; end // C, in=1 -> D, out=0

            3'b110: begin next_state_reg = 2'b10; out_reg = 1'b1; end // D, in=0 -> C, out=1
            3'b111: begin next_state_reg = 2'b01; out_reg = 1'b1; end // D, in=1 -> B, out=1

            default: begin next_state_reg = 2'b00; out_reg = 1'b0; end
        endcase
    end

    assign next_state = next_state_reg;
    assign out = out_reg;

endmodule