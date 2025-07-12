module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

wire sign_a = a[N-1];
wire sign_b = b[N-1];

wire [N-1:0] add_result;
wire [N-1:0] sub_result_a_b;
wire [N-1:0] sub_result_b_a;

assign add_result = a + b;

assign sub_result_a_b = (a[N-1] == 1) ? (~a + 1) - b : a - b;
assign sub_result_b_a = (b[N-1] == 1) ? (~b + 1) - a : b - a;

assign c = (sign_a == sign_b) ? add_result :
            (a >= b) ? sub_result_a_b : sub_result_b_a;

endmodule

// Example testbench
module tb_fixed_point_adder;
    parameter Q = 4, N = 16;
    reg [N-1:0] a, b;
    wire [N-1:0] c;

    fixed_point_adder #(.Q(Q),.N(N)) uut (
       .a(a),
       .b(b),
       .c(c)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        a = 10;
        b = 5;
        #10;
        $display("Result: %d", c);
        a = -10;
        b = 5;
        #10;
        $display("Result: %d", c);
        $finish;
    end
endmodule