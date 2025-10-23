module DFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) 
        q <= d;
endmodule

module TopModule (
    input clk,
    input d,
    output q
);
    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule