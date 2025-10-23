module Cell(
    input clk,
    input [7:0] neighbors,
    input load,
    input data,
    output reg q
);

reg next_q;

always @(*) begin
    case (neighbors)
        8'b00000000, 8'b00000001: next_q = 0;
        8'b00000010: next_q = q;
        8'b00000100: next_q = 1;
        default: next_q = 0;
    endcase
end

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
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
generate
    for (i = 0; i < 256; i++) begin
        wire [7:0] neighbors;
        integer j;
        reg [7:0] neighbor_count;

        always @(*) begin
            neighbor_count = 0;
            for (j = 0; j < 8; j++) begin
                reg [7:0] offset;
                case (j)
                    0: offset = 8'b10000000; // top-left
                    1: offset = 8'b10000001; // top
                    2: offset = 8'b10000010; // top-right
                    3: offset = 8'b10000100; // left
                    4: offset = 8'b10000101; // right
                    5: offset = 8'b10000110; // bottom-left
                    6: offset = 8'b10000111; // bottom
                    7: offset = 8'b10001000; // bottom-right
                endcase

                reg [7:0] neighbor_index;
                reg [3:0] x, y;
                x = i % 16;
                y = i / 16;
                reg [3:0] neighbor_x, neighbor_y;
                neighbor_x = (x + offset[0] - 1 + 16) % 16;
                neighbor_y = (y + offset[1] - 1 + 16) % 16;
                neighbor_index = neighbor_y * 16 + neighbor_x;

                if (q[neighbor_index]) begin
                    neighbor_count = neighbor_count + 1;
                end
            end

            case (neighbor_count)
                0, 1: neighbors = 8'b00000001;
                2: neighbors = 8'b00000010;
                3: neighbors = 8'b00000100;
                default: neighbors = 8'b00001000;
            endcase
        end

        Cell cell(
            .clk(clk),
            .neighbors(neighbors),
            .load(load),
            .data(data[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule