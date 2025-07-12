module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    always @(*) begin
        case ({state, in})
            {A, 1'b0}: begin next_state = A; out = 1'b0; end
            {A, 1'b1}: begin next_state = B; out = 1'b0; end
            {B, 1'b0}: begin next_state = C; out = 1'b0; end
            {B, 1'b1}: begin next_state = B; out = 1'b0; end
            {C, 1'b0}: begin next_state = A; out = 1'b0; end
            {C, 1'b1}: begin next_state = D; out = 1'b0; end
            {D, 1'b0}: begin next_state = C; out = 1'b1; end
            {D, 1'b1}: begin next_state = B; out = 1'b1; end
            default: begin next_state = 4'bxxxx; out = 1'b0; end
        endcase
    end

endmodule