module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shared adjacent bit calculations
    wire [2:0] adj_and = in[2:0] & in[3:1];
    wire [2:0] adj_or = in[2:0] | in[3:1];

    assign out_both = {1'b0, adj_and};
    assign out_any = {adj_or, 1'b0};
    assign out_different = in ^ {in[0], in[3:1]};

endmodule