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
    wire [7:0] next_Q = enable ? {Q[6:0], S} : Q;
    wire [2:0] sel = {A, B, C};

    // 8-bit shift register using DFFs with enable
    dff dff0 (.clk(clk), .d(next_Q[0]), .q(Q[0]));
    dff dff1 (.clk(clk), .d(next_Q[1]), .q(Q[1]));
    dff dff2 (.clk(clk), .d(next_Q[2]), .q(Q[2]));
    dff dff3 (.clk(clk), .d(next_Q[3]), .q(Q[3]));
    dff dff4 (.clk(clk), .d(next_Q[4]), .q(Q[4]));
    dff dff5 (.clk(clk), .d(next_Q[5]), .q(Q[5]));
    dff dff6 (.clk(clk), .d(next_Q[6]), .q(Q[6]));
    dff dff7 (.clk(clk), .d(next_Q[7]), .q(Q[7]));

    // 8:1 mux implemented via direct selection
    assign Z = Q[sel];
endmodule

// Basic D flip-flop module
module dff (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule