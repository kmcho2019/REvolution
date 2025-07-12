// Module A: computes (x ^ y) & x
module A(input wire x, input wire y, output wire a_out);
    assign a_out = (x ^ y) & x;
endmodule

// Module B: output defined by waveform, here interpreted as ~(x ^ y)
module B(input wire x, input wire y, output wire b_out);
    assign b_out = ~(x ^ y);
endmodule

// Combined AB module instantiates A and B modules and outputs their results
module AB(input wire x, input wire y, output wire a_out, output wire b_out);
    A a_inst(.x(x), .y(y), .a_out(a_out));
    B b_inst(.x(x), .y(y), .b_out(b_out));
endmodule

// Top module wiring two AB instances and combining outputs as described
module TopModule(input wire x, input wire y, output wire z);
    wire a1, b1, a2, b2;
    wire or_out, and_out;

    AB ab1(.x(x), .y(y), .a_out(a1), .b_out(b1));
    AB ab2(.x(x), .y(y), .a_out(a2), .b_out(b2));

    assign or_out = a1 | b1;
    assign and_out = a2 & b2;
    assign z = or_out ^ and_out;
endmodule