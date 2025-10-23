module TopModule #(
    parameter WIDTH = 4,
    parameter POS_WIDTH = $clog2(WIDTH)
)(
    input  logic [WIDTH-1:0] in,
    output logic [POS_WIDTH-1:0] pos
);

always_comb begin
    pos = 0;
    for (int i = WIDTH - 1; i >= 0; i--) begin
        if (in[i]) begin
            pos = i;
            break;
        end
    end
end

endmodule