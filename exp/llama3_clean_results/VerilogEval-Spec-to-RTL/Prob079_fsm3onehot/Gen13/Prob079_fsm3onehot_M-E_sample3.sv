module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding
    wire [3:0] A = 4'b0001;
    wire [3:0] B = 4'b0010;
    wire [3:0] C = 4'b0100;
    wire [3:0] D = 4'b1000;

    // State transition and output logic using a lookup table approach
    reg [3:0] next_state_reg;
    reg out_reg;

    always @(*) begin
        case ({state, in})
            {A, 1'b0}: begin next_state_reg = A; out_reg = 1'b0; end
            {A, 1'b1}: begin next_state_reg = B; out_reg = 1'b0; end
            {B, 1'b0}: begin next_state_reg = C; out_reg = 1'b0; end
            {B, 1'b1}: begin next_state_reg = B; out_reg = 1'b0; end
            {C, 1'b0}: begin next_state_reg = A; out_reg = 1'b0; end
            {C, 1'b1}: begin next_state_reg = D; out_reg = 1'b0; end
            {D, 1'b0}: begin next_state_reg = C; out_reg = 1'b1; end
            {D, 1'b1}: begin next_state_reg = B; out_reg = 1'b1; end
            default: begin next_state_reg = 4'bxxxx; out_reg = 1'b0; end
        endcase
    end

    assign next_state = next_state_reg;
    assign out = out_reg;

endmodule