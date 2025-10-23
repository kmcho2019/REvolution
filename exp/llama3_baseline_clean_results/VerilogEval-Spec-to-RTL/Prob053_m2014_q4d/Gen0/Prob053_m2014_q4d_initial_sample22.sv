// D Flip-Flop module
module DFF(clk, d, q);
    input clk, d;
    output q;
    reg q;

    always @(posedge clk)
        q <= d;
endmodule

// TopModule
module TopModule(clk, in, out);
    input clk, in;
    output out;
    wire d;

    // Instantiate D flip-flop and XOR gate
    DFF u_dff(clk, d, out);
    assign d = in ^ out;
endmodule