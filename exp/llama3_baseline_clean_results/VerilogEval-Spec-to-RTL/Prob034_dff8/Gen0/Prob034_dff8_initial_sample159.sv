module TopModule(clk, d, q);
    input clk;
    input [7:0] d;
    output [7:0] q;

    // Define 8 D flip-flops, each with 1-bit data input and output
    wire [7:0] dff_out;

    // Instantiate 8 D flip-flops
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            DFF dff_i (.clk(clk), .d(d[i]), .q(dff_out[i]));
        end
    endgenerate

    // Assign the output of DFFs to the output port 'q'
    assign q = dff_out;
endmodule

// D flip-flop module
module DFF(clk, d, q);
    input clk;
    input d;
    output reg q;

    always @(posedge clk) begin
        q <= d;
    end
endmodule