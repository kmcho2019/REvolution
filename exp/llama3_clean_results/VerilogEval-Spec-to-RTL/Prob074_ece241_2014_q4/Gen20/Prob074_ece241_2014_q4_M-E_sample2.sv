// Sub-module for XOR gate and D flip-flop
module XorDff(
    input clk,
    input x,
    input q_prev,
    output reg q_next,
    output reg xor_out
);
    always @(posedge clk) begin
        q_next <= x ^ q_prev;
    end
    assign xor_out = x ^ q_prev;
endmodule

// Sub-module for AND gate and D flip-flop
module AndDff(
    input clk,
    input x,
    input q_prev,
    output reg q_next,
    output reg and_out
);
    wire q_prev_c = ~q_prev;
    always @(posedge clk) begin
        q_next <= x & q_prev_c;
    end
    assign and_out = x & q_prev_c;
endmodule

// Sub-module for OR gate and D flip-flop
module OrDff(
    input clk,
    input x,
    input q_prev,
    output reg q_next,
    output reg or_out
);
    wire q_prev_c = ~q_prev;
    always @(posedge clk) begin
        q_next <= x | q_prev_c;
    end
    assign or_out = x | q_prev_c;
endmodule

// Top-level module
module TopModule(
    input clk,
    input x,
    output reg z
);
    reg q_xor = 1'b0;
    reg q_and = 1'b0;
    reg q_or = 1'b0;
    wire xor_out, and_out, or_out;

    XorDff xor_dff(
        .clk(clk),
        .x(x),
        .q_prev(q_xor),
        .q_next(q_xor),
        .xor_out(xor_out)
    );

    AndDff and_dff(
        .clk(clk),
        .x(x),
        .q_prev(q_and),
        .q_next(q_and),
        .and_out(and_out)
    );

    OrDff or_dff(
        .clk(clk),
        .x(x),
        .q_prev(q_or),
        .q_next(q_or),
        .or_out(or_out)
    );

    assign z = ~(xor_out | and_out | or_out);
endmodule