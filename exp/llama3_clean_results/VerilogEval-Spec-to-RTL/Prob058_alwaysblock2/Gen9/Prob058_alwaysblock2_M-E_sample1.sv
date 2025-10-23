// Define a configurable XOR module
module xor_config #(
    parameter STYLE = 0, // 0: continuous assignment, 1: combinational, 2: sequential
    parameter CLK_ENABLE = 1 // 1: enable clocked operation, 0: disable
)(
    input  clk,
    input  a,
    input  b,
    output out
);
    reg [1:0] style;
    reg clk_enable;

    // Initialize parameters
    initial begin
        style = STYLE;
        clk_enable = CLK_ENABLE;
    end

    // Continuous assignment
    if (style == 0) begin
        assign out = a ^ b;
    end
    // Combinational always block
    else if (style == 1) begin
        always_comb begin
            out = a ^ b;
        end
    end
    // Clocked always block
    else if (style == 2 && clk_enable) begin
        reg out_reg;
        always_ff @(posedge clk) begin
            out_reg <= a ^ b;
        end
        assign out = out_reg;
    end
endmodule

// TopModule instantiating configurable XOR modules
module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);
    xor_config #(.STYLE(0),.CLK_ENABLE(0)) u_assign(
       .clk(1'b0),
       .a(a),
       .b(b),
       .out(out_assign)
    );

    xor_config #(.STYLE(1),.CLK_ENABLE(0)) u_always_comb(
       .clk(1'b0),
       .a(a),
       .b(b),
       .out(out_always_comb)
    );

    xor_config #(.STYLE(2),.CLK_ENABLE(1)) u_always_ff(
       .clk(clk),
       .a(a),
       .b(b),
       .out(out_always_ff)
    );
endmodule