module TopModule (
    input        x,
    input  [2:0] y,   // present state
    output       Y0,
    output reg   z
);

    reg [2:0] next_state;

    always @(*) begin
        case ({y, x})
            4'b0000: begin next_state = 3'b000; z = 1'b0; end
            4'b0001: begin next_state = 3'b001; z = 1'b0; end
            4'b0010: begin next_state = 3'b001; z = 1'b0; end
            4'b0011: begin next_state = 3'b100; z = 1'b0; end
            4'b0100: begin next_state = 3'b010; z = 1'b0; end
            4'b0101: begin next_state = 3'b001; z = 1'b0; end
            4'b0110: begin next_state = 3'b001; z = 1'b1; end
            4'b0111: begin next_state = 3'b010; z = 1'b1; end
            4'b1000: begin next_state = 3'b011; z = 1'b1; end
            4'b1001: begin next_state = 3'b100; z = 1'b1; end
            default: begin next_state = 3'b000; z = 1'b0; end
        endcase
    end

    assign Y0 = next_state[0];

endmodule