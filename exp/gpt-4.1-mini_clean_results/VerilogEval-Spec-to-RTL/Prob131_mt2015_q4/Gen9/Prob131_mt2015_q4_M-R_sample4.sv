module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
    // B implements XNOR(x,y)
    assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output reg z);
    wire a_out;
    wire b_out;
    wire or_out;
    wire and_out;

    // Instantiate A and B once each
    A inst_A(.x(x), .y(y), .z(a_out));
    B inst_B(.x(x), .y(y), .z(b_out));

    // Intermediate signals for OR and AND of A and B outputs
    wire or_input_1 = a_out;
    wire or_input_2 = b_out;

    wire and_input_1 = a_out;
    wire and_input_2 = b_out;

    assign or_out = or_input_1 | or_input_2;
    assign and_out = and_input_1 & and_input_2;

    // Use always_comb block for final XOR output
    always @(*) begin
        z = or_out ^ and_out;
    end
endmodule