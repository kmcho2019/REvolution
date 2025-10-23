module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [7:0] odd
);

    reg [7:0] rem;
    wire [7:0] rem_next [0:15];
    wire [15:0] cmp_res;

    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : div_loop
            wire [7:0] rem_ext = (i == 15) ? 8'b0 : rem_next[i+1];
            wire [8:0] rem_temp = {rem_ext, A[i]};
            assign cmp_res[i] = (rem_temp >= {1'b0, B});
            assign rem_next[i] = cmp_res[i] ? (rem_temp - B) : rem_temp[7:0];
        end
    endgenerate

    always @(*) begin
        rem = rem_next[0];
        result = cmp_res;
        odd = rem;
    end

endmodule