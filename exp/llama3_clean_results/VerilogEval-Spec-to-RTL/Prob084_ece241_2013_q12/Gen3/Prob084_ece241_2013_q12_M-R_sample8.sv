module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

    reg [7:0] Q;

    // 8-bit shift register
    always @(posedge clk) begin
        if (enable) begin
            Q[7:1] <= Q[6:0];
            Q[0] <= S;
        end
    end

    // Simplified multiplexer to select the output
    assign Z = Q[{A, B, C}];

endmodule

module testbench;
    reg clk;
    reg enable;
    reg S;
    reg A;
    reg B;
    reg C;
    wire Z;

    TopModule uut(
        .clk(clk),
        .enable(enable),
        .S(S),
        .A(A),
        .B(B),
        .C(C),
        .Z(Z)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        clk = 0;
        enable = 0;
        S = 0;
        A = 0;
        B = 0;
        C = 0;
        #100;
        $finish;
    end

    always #5 clk = ~clk;

    initial begin
        #10;
        enable = 1'b1;
        S = 1'b1;
        #10;
        A = 1'b1;
        #10;
        B = 1'b1;
        #10;
        C = 1'b1;
        #10;
        S = 1'b0;
        #10;
        A = 1'b0;
        #10;
        B = 1'b0;
        #10;
        C = 1'b0;
    end

    initial begin
        #5;
        $display("Z: %b", Z);
        #10;
        $display("Z: %b", Z);
        #10;
        $display("Z: %b", Z);
        #10;
        $display("Z: %b", Z);
        #10;
        $display("Z: %b", Z);
    end
endmodule