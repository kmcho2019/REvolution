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

reg [7:0] Q;

DFF dff0(
   .clk(clk),
   .enable(enable),
   .D(S),
   .Q(Q[0])
);

for (genvar i = 1; i < 8; i++) begin
    DFF dff(
       .clk(clk),
       .enable(enable),
       .D(Q[i-1]),
       .Q(Q[i])
    );
end

assign Z = Q[{A, B, C}];

endmodule