module DFF (
    input clk,
    input enable,
    input D,
    output reg Q
);
    always @(posedge clk) begin
        if (enable) Q <= D;
    end
endmodule

module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    wire [7:0] Q;
    wire [2:0] sel = {A, B, C};

    // 8-bit shift register using individual DFFs
    DFF dff0 (.clk(clk), .enable(enable), .D(S),       .Q(Q[0]));
    DFF dff1 (.clk(clk), .enable(enable), .D(Q[0]),    .Q(Q[1]));
    DFF dff2 (.clk(clk), .enable(enable), .D(Q[1]),    .Q(Q[2]));
    DFF dff3 (.clk(clk), .enable(enable), .D(Q[2]),    .Q(Q[3]));
    DFF dff4 (.clk(clk), .enable(enable), .D(Q[3]),    .Q(Q[4]));
    DFF dff5 (.clk(clk), .enable(enable), .D(Q[4]),    .Q(Q[5]));
    DFF dff6 (.clk(clk), .enable(enable), .D(Q[5]),    .Q(Q[6]));
    DFF dff7 (.clk(clk), .enable(enable), .D(Q[6]),    .Q(Q[7]));

    // 8:1 Mux implemented with assign
    assign Z = (sel == 3'b000) ? Q[0] :
               (sel == 3'b001) ? Q[1] :
               (sel == 3'b010) ? Q[2] :
               (sel == 3'b011) ? Q[3] :
               (sel == 3'b100) ? Q[4] :
               (sel == 3'b101) ? Q[5] :
               (sel == 3'b110) ? Q[6] :
               Q[7];
endmodule