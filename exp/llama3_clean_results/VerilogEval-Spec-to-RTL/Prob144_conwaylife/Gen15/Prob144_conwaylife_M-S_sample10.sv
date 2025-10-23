module Cell(
    input clk,
    input load,
    input data,
    input [2:0] neighbors,
    output reg q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        case (neighbors)
            3'b000, 3'b001: q <= 0;
            3'b010: q <= q;
            3'b011: q <= 1;
            default: q <= 0;
        endcase
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
        wire [2:0] neighbors;
        integer j;
        reg [2:0] neighbor_count;

        always @(*) begin
            neighbor_count = 0;
            for (j = 0; j < 8; j++) begin
                reg [3:0] x, y, neighbor_x, neighbor_y;
                x = i % 16;
                y = i / 16;
                case (j)
                    0: begin neighbor_x = (x - 1 + 16) % 16; neighbor_y = (y - 1 + 16) % 16; end
                    1: begin neighbor_x = x; neighbor_y = (y - 1 + 16) % 16; end
                    2: begin neighbor_x = (x + 1) % 16; neighbor_y = (y - 1 + 16) % 16; end
                    3: begin neighbor_x = (x - 1 + 16) % 16; neighbor_y = y; end
                    4: begin neighbor_x = (x + 1) % 16; neighbor_y = y; end
                    5: begin neighbor_x = (x - 1 + 16) % 16; neighbor_y = (y + 1) % 16; end
                    6: begin neighbor_x = x; neighbor_y = (y + 1) % 16; end
                    7: begin neighbor_x = (x + 1) % 16; neighbor_y = (y + 1) % 16; end
                endcase
                if (q[neighbor_y * 16 + neighbor_x]) begin
                    neighbor_count = neighbor_count + 1;
                end
            end
            neighbors = neighbor_count[2:0];
        end

        Cell cell(
           .clk(clk),
           .load(load),
           .data(data[i]),
           .neighbors(neighbors),
           .q(q[i])
        );
    end
endgenerate

endmodule