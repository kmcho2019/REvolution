module DFF(
    input clk,
    input enable,
    input D,
    output reg Q
);

always @(posedge clk) begin
    if (enable) begin
        Q <= D;
    end
end

endmodule

module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

wire [7:0] Q;

DFF dff0(
    .clk(clk),
    .enable(enable),
    .D(S),
    .Q(Q[0])
);

DFF dff1(
    .clk(clk),
    .enable(enable),
    .D(Q[0]),
    .Q(Q[1])
);

DFF dff2(
    .clk(clk),
    .enable(enable),
    .D(Q[1]),
    .Q(Q[2])
);

DFF dff3(
    .clk(clk),
    .enable(enable),
    .D(Q[2]),
    .Q(Q[3])
);

DFF dff4(
    .clk(clk),
    .enable(enable),
    .D(Q[3]),
    .Q(Q[4])
);

DFF dff5(
    .clk(clk),
    .enable(enable),
    .D(Q[4]),
    .Q(Q[5])
);

DFF dff6(
    .clk(clk),
    .enable(enable),
    .D(Q[5]),
    .Q(Q[6])
);

DFF dff7(
    .clk(clk),
    .enable(enable),
    .D(Q[6]),
    .Q(Q[7])
);

assign Z = Q[{A, B, C}];

endmodule