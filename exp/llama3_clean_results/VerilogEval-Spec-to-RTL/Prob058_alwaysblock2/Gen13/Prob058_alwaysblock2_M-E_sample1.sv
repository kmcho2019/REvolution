// Define a pipeline stage for input handling
module input_stage(
    input  clk,
    input  a,
    input  b,
    output reg a_reg,
    output reg b_reg
);
    always_ff @(posedge clk) begin
        a_reg <= a;
        b_reg <= b;
    end
endmodule

// Define a pipeline stage for continuous assignment
module assign_stage(
    input  a,
    input  b,
    output out_assign
);
    assign out_assign = a ^ b;
endmodule

// Define a pipeline stage for combinational always block
module comb_stage(
    input  a,
    input  b,
    output reg out_always_comb
);
    always_comb begin
        out_always_comb = a ^ b;
    end
endmodule

// Define a pipeline stage for clocked always block
module ff_stage(
    input  clk,
    input  a,
    input  b,
    output reg out_always_ff
);
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end
endmodule

// TopModule implementing the pipeline
module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);
    reg a_reg, b_reg;

    input_stage u_input(
       .clk(clk),
       .a(a),
       .b(b),
       .a_reg(a_reg),
       .b_reg(b_reg)
    );

    assign_stage u_assign(
       .a(a_reg),
       .b(b_reg),
       .out_assign(out_assign)
    );

    comb_stage u_comb(
       .a(a_reg),
       .b(b_reg),
       .out_always_comb(out_always_comb)
    );

    ff_stage u_ff(
       .clk(clk),
       .a(a_reg),
       .b(b_reg),
       .out_always_ff(out_always_ff)
    );
endmodule