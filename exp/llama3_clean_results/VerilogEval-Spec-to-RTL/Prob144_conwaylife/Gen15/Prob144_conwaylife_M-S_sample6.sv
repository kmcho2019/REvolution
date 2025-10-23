module Cell(
    input clk,
    input load,
    input data,
    input [7:0] neighbors,
    output reg q
);

always @(*) begin
    case (neighbors)
        8'b00000000, 8'b00000001: q = 0;
        8'b00000010: q = q;
        8'b00000100: q = 1;
        default: q = 0;
    endcase
end

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end 
end

endmodule

module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

genvar i;
reg [7:0] neighbors;

generate
    for (i = 0; i < 256; i++) begin
        integer row = i / 16;
        integer col = i % 16;
        always @(*) begin
            neighbors[0] = q[((((col - 1) % 16) + 16) % 16) + (((row - 1) % 16) + 16) % 16 * 16];
            neighbors[1] = q[((col + 16) % 16) + (((row - 1) % 16) + 16) % 16 * 16];
            neighbors[2] = q[((((col + 1) % 16) + 16) % 16) + (((row - 1) % 16) + 16) % 16 * 16];
            neighbors[3] = q[((((col - 1) % 16) + 16) % 16) + ((row + 16) % 16) * 16];
            neighbors[4] = q[((col + 16) % 16) + ((row + 16) % 16) * 16];
            neighbors[5] = q[((((col + 1) % 16) + 16) % 16) + ((row + 16) % 16) * 16];
            neighbors[6] = q[((((col - 1) % 16) + 16) % 16) + (((row + 1) % 16) + 16) % 16 * 16];
            neighbors[7] = q[((col + 16) % 16) + (((row + 1) % 16) + 16) % 16 * 16];

            Cell cell(
                .clk(clk),
                .load(load),
                .data(data[i]),
                .neighbors(neighbors),
                .q(q[i])
            );
        end
    end
endgenerate

endmodule