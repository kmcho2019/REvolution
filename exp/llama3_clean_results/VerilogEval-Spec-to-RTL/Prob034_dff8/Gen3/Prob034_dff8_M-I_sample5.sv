// Define a generic D flip-flop module
module DFF(clk, d, q);
    input clk;
    input d;
    output reg q;

    always @(posedge clk) begin
        q <= d;
    end
endmodule

// Define the TopModule using the generic D flip-flop module
module TopModule(clk, d, q);
    input clk;
    input [7:0] d;
    output [7:0] q;

    // Instantiate 8 instances of the D flip-flop module using a generate loop
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            DFF dff(clk, d[i], q[i]);
        end
    endgenerate
endmodule