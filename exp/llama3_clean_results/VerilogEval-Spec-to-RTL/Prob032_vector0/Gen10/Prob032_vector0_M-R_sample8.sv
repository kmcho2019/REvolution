module TopModule #(
    parameter VECTOR_WIDTH = 3
)(
    input [VECTOR_WIDTH-1:0] vec,
    output [VECTOR_WIDTH-1:0] outv,
    output [VECTOR_WIDTH-1:0] o
);
    
    assign outv = vec;
    for (genvar i = 0; i < VECTOR_WIDTH; i++) begin
        assign o[i] = vec[i];
    end

endmodule