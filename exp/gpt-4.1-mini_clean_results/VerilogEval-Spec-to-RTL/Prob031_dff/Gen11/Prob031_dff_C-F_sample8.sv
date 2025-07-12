module DFF (
    input clk,
    input d,
    output reg q
);
    wire load_en = (d != q); // Enable flip-flop load only if data changes

    always @(posedge clk)
        if (load_en)
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