module TopModule (
    input clk,
    input in,
    output out
);

    wire state;
    assign state = (clk) ? (in ^ out) : state;
    assign out = state;

endmodule