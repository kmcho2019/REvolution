module TopModule(
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;
wire [255:0] q_next;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= q_next;
    end
end

genvar i, j;
generate
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            wire [7:0] neighbors;
            wire [2:0] neighbor_count;
            assign neighbors[0] = q_reg[((i-1+16)%16)*16 + j]; // top
            assign neighbors[1] = q_reg[((i-1+16)%16)*16 + (j+1)%16]; // top-right
            assign neighbors[2] = q_reg[i*16 + (j+1)%16]; // right
            assign neighbors[3] = q_reg[((i+1)%16)*16 + (j+1)%16]; // bottom-right
            assign neighbors[4] = q_reg[((i+1)%16)*16 + j]; // bottom
            assign neighbors[5] = q_reg[((i+1)%16)*16 + (j-1+16)%16]; // bottom-left
            assign neighbors[6] = q_reg[i*16 + (j-1+16)%16]; // left
            assign neighbors[7] = q_reg[((i-1+16)%16)*16 + (j-1+16)%16]; // top-left

            assign neighbor_count = neighbors[0] + neighbors[1] + neighbors[2] + neighbors[3] + neighbors[4] + neighbors[5] + neighbors[6] + neighbors[7];

            assign q_next[i*16 + j] = (neighbor_count == 3 || (q_reg[i*16 + j] && neighbor_count == 2)) ? 1'b1 : 1'b0;
        end
    end
endgenerate

assign q = q_reg;

endmodule