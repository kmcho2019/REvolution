module TopModule #(
    parameter WIDTH = 4,
    parameter POS_WIDTH = $clog2(WIDTH)
)(
    input  logic [WIDTH-1:0] in,
    output logic [POS_WIDTH-1:0] pos
);

assign pos = (in[WIDTH-1]) ? (WIDTH-1) :
             (in[WIDTH-2]) ? (WIDTH-2) :
             (in[WIDTH-3]) ? (WIDTH-3) :
             (in[WIDTH-2:0] == 1'b0) ? 0 :
             (in[WIDTH-4]);

endmodule