module TopModule #(
    parameter VECTOR_SIZE = 3
)(
    input  [VECTOR_SIZE-1:0] vec,
    output [VECTOR_SIZE-1:0] outv,
    output [VECTOR_SIZE-1:0] o
);

integer i;
assign outv = vec;
for (i = 0; i < VECTOR_SIZE; i++) begin
    assign o[i] = vec[i];
end

endmodule