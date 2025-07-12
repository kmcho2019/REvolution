module TopModule #(
    parameter WIDTH = 4,
    parameter POS_WIDTH = $clog2(WIDTH)
)(
    input  logic [WIDTH-1:0] in,
    output logic [POS_WIDTH-1:0] pos
);

always_comb begin
    pos = (in[WIDTH-1]) ? (WIDTH-1) :
           (in[WIDTH-2]) ? (WIDTH-2) :
           (in[WIDTH-3]) ? (WIDTH-3) :
           (in[WIDTH-4]) ? (WIDTH-4) :
           0;
end

endmodule