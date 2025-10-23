module TopModule(input clk, input a, output q);
    DFF dff_inst (
        .clk(clk),
        .d(~a),
        .q(q)
    );
endmodule

// Compact D flip-flop module
module DFF(input clk, input d, output reg q);
    always @(posedge clk) q <= d;
endmodule