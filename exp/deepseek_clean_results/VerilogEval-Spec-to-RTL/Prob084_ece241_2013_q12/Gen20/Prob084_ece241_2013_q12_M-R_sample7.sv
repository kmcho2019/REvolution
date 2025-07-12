module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    // Explicit 8-bit shift register using DFF primitives
    wire [7:0] Q;
    wire [7:0] next_Q;
    wire gated_clk = clk & enable;

    // Chain of D flip-flops with gated clock
    DFF dff0 (.clk(gated_clk), .D(enable ? S : Q[0]), .Q(Q[0]));
    DFF dff1 (.clk(gated_clk), .D(enable ? Q[0] : Q[1]), .Q(Q[1]));
    DFF dff2 (.clk(gated_clk), .D(enable ? Q[1] : Q[2]), .Q(Q[2]));
    DFF dff3 (.clk(gated_clk), .D(enable ? Q[2] : Q[3]), .Q(Q[3]));
    DFF dff4 (.clk(gated_clk), .D(enable ? Q[3] : Q[4]), .Q(Q[4]));
    DFF dff5 (.clk(gated_clk), .D(enable ? Q[4] : Q[5]), .Q(Q[5]));
    DFF dff6 (.clk(gated_clk), .D(enable ? Q[5] : Q[6]), .Q(Q[6]));
    DFF dff7 (.clk(gated_clk), .D(enable ? Q[6] : Q[7]), .Q(Q[7]));

    // 8:1 Mux implemented directly
    wire [2:0] sel = {A, B, C};
    assign Z = Q[sel];

    // D Flip-flop primitive definition
    primitive DFF (output reg Q, input clk, D);
        table
            // clk D : Q : Q+
            (01) 0 : ? : 0;
            (01) 1 : ? : 1;
            (0?) ? : ? : -;
            (?0) ? : ? : -;
            (??) * : ? : -;
        endtable
    endprimitive
endmodule