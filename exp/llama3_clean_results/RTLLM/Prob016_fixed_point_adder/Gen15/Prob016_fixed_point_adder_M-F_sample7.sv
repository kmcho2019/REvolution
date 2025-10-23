module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  clk,
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Unified approach for handling addition and subtraction
wire add_op = sign_a == sign_b;

always @(posedge clk) begin
    if (add_op) begin
        // Absolute value addition
        res <= (a[N-1] == 1'b0) ? (a + b) : ((~a + 1) + (~b + 1));
    end else begin
        // Absolute value subtraction
        if (a >= b) begin
            res <= (a[N-1] == 1'b0) ? (a - b) : ((~b + 1) - (~a + 1));
        end else begin
            res <= (b[N-1] == 1'b0) ? (b - a) : ((~a + 1) - (~b + 1));
        end
    end
end

// Explicit overflow handling
always @(posedge clk) begin
    if (res >= (2**N - 1)) begin
        res <= (2**N - 1); // Saturate to maximum value on overflow
    end else if (res < 0) begin
        res <= 0; // Saturate to minimum value on underflow
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