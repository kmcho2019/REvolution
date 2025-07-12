module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    wire [WIDTH-1:0] temp;

    assign temp = {in[WIDTH/2-1:0], in[WIDTH-1:WIDTH/2]};

    genvar i;
    generate
        for (i = 0; i < WIDTH/2; i++) begin
            assign out[i] = temp[WIDTH-1-i];
            assign out[WIDTH-1-i] = temp[i];
        end
    endgenerate

    // Handle the case where WIDTH is odd
    if (WIDTH % 2 == 1) begin
        assign out[WIDTH/2] = temp[WIDTH/2];
    end

endmodule