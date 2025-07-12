module TopModule(
    input  [99:0] in,
    output [99:0] out
);

parameter WIDTH = 100;

if (WIDTH == 1) begin
    assign out[0] = in[0];
end else begin
    localparam HALF_WIDTH = WIDTH / 2;
    wire [HALF_WIDTH-1:0] half1, half2;
    assign half1 = in[WIDTH-1:HALF_WIDTH];
    assign half2 = in[HALF_WIDTH-1:0];
    TopModule #(.WIDTH(HALF_WIDTH)) u_half1 (
       .in(half2),
       .out(out[WIDTH-1:HALF_WIDTH])
    );
    TopModule #(.WIDTH(HALF_WIDTH)) u_half2 (
       .in(half1),
       .out(out[HALF_WIDTH-1:0])
    );
end

endmodule