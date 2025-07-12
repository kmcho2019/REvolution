module TopModule #(
    parameter WIDTH = 100
) (
    input  logic [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out
);

    integer i;
    always @(*) begin
        for (i = 0; i < WIDTH; i++) begin
            out[i] = in[WIDTH - 1 - i];
        end
    end

endmodule