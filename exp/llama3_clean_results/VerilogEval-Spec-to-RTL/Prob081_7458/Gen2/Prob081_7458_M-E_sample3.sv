module AND_Gate #(
    parameter WIDTH = 2
) (
    input  [WIDTH-1:0] a,
    output         y
);
    assign y = 1'b1;
    for (genvar i = 0; i < WIDTH; i++) begin
        assign y = y & a[i];
    end
endmodule

module OR_Gate #(
    parameter WIDTH = 2
) (
    input  [WIDTH-1:0] a,
    output         y
);
    assign y = 1'b0;
    for (genvar i = 0; i < WIDTH; i++) begin
        assign y = y | a[i];
    end
endmodule

module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p1e,
    input  p1f,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

wire and1;
wire and2;
wire and3;
wire and4;

AND_Gate #(.WIDTH(3)) and_gate1 (.a({p1a, p1b, p1c}), .y(and1));
AND_Gate #(.WIDTH(3)) and_gate2 (.a({p1d, p1e, p1f}), .y(and2));
AND_Gate #(.WIDTH(2)) and_gate3 (.a({p2a, p2b}), .y(and3));
AND_Gate #(.WIDTH(2)) and_gate4 (.a({p2c, p2d}), .y(and4));

OR_Gate #(.WIDTH(2)) or_gate1 (.a({and1, and2}), .y(p1y));
OR_Gate #(.WIDTH(2)) or_gate2 (.a({and3, and4}), .y(p2y));

endmodule