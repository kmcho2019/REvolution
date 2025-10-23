module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

always @(*) begin
    next_q = q;
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            reg [2:0] neighbors;
            neighbors = 0;
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if ((x == 0) && (y == 0)) begin
                        continue;
                    end
                    reg [7:0] neighbor_row;
                    reg [7:0] neighbor_col;
                    neighbor_row = (i + x + 16) % 16;
                    neighbor_col = (j + y + 16) % 16;
                    if (q[neighbor_row * 16 + neighbor_col]) begin
                        neighbors = neighbors + 1;
                    end
                end
            end
            reg [7:0] index;
            index = i * 16 + j;
            case (neighbors)
                3'd0, 3'd1: next_q[index] = 1'd0;
                3'd2: next_q[index] = q[index];
                3'd3: next_q[index] = 1'd1;
                default: next_q[index] = 1'd0;
            endcase
        end
    end
end

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule