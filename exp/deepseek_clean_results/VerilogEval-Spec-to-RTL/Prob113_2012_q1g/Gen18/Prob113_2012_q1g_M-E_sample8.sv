module TopModule(
    input [3:0] x,
    output f
);
    wire [1:0] upper_bits = x[3:2];
    wire [1:0] lower_bits = x[1:0];
    reg out;

    always @(*) begin
        case(upper_bits)
            2'b00: out = (lower_bits == 2'b00) || (lower_bits == 2'b10);
            2'b01: out = 1'b0;
            2'b11: out = (lower_bits != 2'b10);
            2'b10: out = (lower_bits != 2'b11);
            default: out = 1'b0;
        endcase
    end

    assign f = out;
endmodule