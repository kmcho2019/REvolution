module TopModule #(
    parameter WIDTH = 3
)(
    input  [WIDTH-1:0] vec,
    output [WIDTH-1:0] outv,
    output [WIDTH-1:0] o
);

assign outv = vec;

generate
    for (genvar i = 0; i < WIDTH; i++) begin
        assign o[i] = vec[i];
    end
endgenerate

endmodule