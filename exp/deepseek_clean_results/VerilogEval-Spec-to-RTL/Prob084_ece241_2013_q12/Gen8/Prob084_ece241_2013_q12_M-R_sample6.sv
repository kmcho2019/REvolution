module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    // Shift register implementation using explicit DFFs
    wire [7:0] Q;
    wire [7:0] D;
    
    // Input connections for each flip-flop
    assign D[0] = enable ? S : Q[0];
    assign D[1] = enable ? Q[0] : Q[1];
    assign D[2] = enable ? Q[1] : Q[2];
    assign D[3] = enable ? Q[2] : Q[3];
    assign D[4] = enable ? Q[3] : Q[4];
    assign D[5] = enable ? Q[4] : Q[5];
    assign D[6] = enable ? Q[5] : Q[6];
    assign D[7] = enable ? Q[6] : Q[7];
    
    // DFF instances
    dff dff0 (.clk(clk), .d(D[0]), .q(Q[0]));
    dff dff1 (.clk(clk), .d(D[1]), .q(Q[1]));
    dff dff2 (.clk(clk), .d(D[2]), .q(Q[2]));
    dff dff3 (.clk(clk), .d(D[3]), .q(Q[3]));
    dff dff4 (.clk(clk), .d(D[4]), .q(Q[4]));
    dff dff5 (.clk(clk), .d(D[5]), .q(Q[5]));
    dff dff6 (.clk(clk), .d(D[6]), .q(Q[6]));
    dff dff7 (.clk(clk), .d(D[7]), .q(Q[7]));
    
    // 8:1 Mux implementation using case statement
    wire [2:0] sel = {A, B, C};
    
    assign Z = (sel == 3'b000) ? Q[0] :
              (sel == 3'b001) ? Q[1] :
              (sel == 3'b010) ? Q[2] :
              (sel == 3'b011) ? Q[3] :
              (sel == 3'b100) ? Q[4] :
              (sel == 3'b101) ? Q[5] :
              (sel == 3'b110) ? Q[6] :
              Q[7];
endmodule

// D flip-flop module
module dff (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule