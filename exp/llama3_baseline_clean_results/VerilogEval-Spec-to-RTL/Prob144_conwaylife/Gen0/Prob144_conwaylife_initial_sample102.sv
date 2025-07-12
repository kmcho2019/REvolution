module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;
reg [255:0] next_q;

integer i, j, x, y;
integer alive_neighbors;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_q;
    end
end

always @(*) begin
    next_q = q_reg;
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            alive_neighbors = 0;
            for (x = -1; x <= 1; x = x + 1) begin
                for (y = -1; y <= 1; y = y + 1) begin
                    if (x == 0 && y == 0) begin
                        // skip self
                    end else begin
                        integer neighbor_i = (i + x + 16) % 16;
                        integer neighbor_j = (j + y + 16) % 16;
                        integer neighbor_index = neighbor_i * 16 + neighbor_j;
                        if (q_reg[neighbor_index]) begin
                            alive_neighbors = alive_neighbors + 1;
                        end
                    end
                end
            end
            integer cell_index = i * 16 + j;
            case (alive_neighbors)
                0, 1: next_q[cell_index] = 0;
                2: next_q[cell_index] = q_reg[cell_index];
                3: next_q[cell_index] = 1;
                default: next_q[cell_index] = 0;
            endcase
        end
    end
end

assign q = q_reg;

endmodule