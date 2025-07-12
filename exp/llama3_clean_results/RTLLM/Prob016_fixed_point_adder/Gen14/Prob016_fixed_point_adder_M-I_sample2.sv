module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  clk,
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

wire sign_a = a[N-1];
wire sign_b = b[N-1];

always @(posedge clk) begin
    if (sign_a == sign_b) begin
        // Absolute value addition
        res <= a + b;
    end else begin
        // Absolute value subtraction
        if (a >= b) begin
            res <= a - b;
        end else begin
            res <= b - a;
        end
    end
end

assign c = res;

// Optional: Adding a pipelined stage for improved performance
// reg [N-1:0] pipe_res;
// always @(posedge clk) begin
//     pipe_res <= res;
// end
// assign c = pipe_res;

endmodule

// Example testbench
module tb_fixed_point_adder;
    parameter Q = 4, N = 16;
    reg clk;
    reg [N-1:0] a, b;
    wire [N-1:0] c;

    fixed_point_adder #(.Q(Q),.N(N)) uut (
       .clk(clk),
       .a(a),
       .b(b),
       .c(c)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        a = 10;
        b = 5;
        #10;
        $display("Result: %d", c);
        $finish;
    end
endmodule