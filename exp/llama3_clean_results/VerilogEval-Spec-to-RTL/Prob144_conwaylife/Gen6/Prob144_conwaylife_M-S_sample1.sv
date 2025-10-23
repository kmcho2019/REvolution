module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (reg [7:0] i = 0; i < 256; i = i + 1) begin
            reg [2:0] alive_neighbors;
            alive_neighbors = 0;
            for (reg [2:0] x = -1; x <= 1; x = x + 1) begin
                for (reg [2:0] y = -1; y <= 1; y = y + 1) begin
                    if (x == 0 && y == 0) begin
                        // Skip the current cell
                    end else begin
                        reg [7:0] neighbor_index;
                        reg [3:0] x_index = (i / 16 + x + 16) % 16;
                        reg [3:0] y_index = (i % 16 + y + 16) % 16;
                        neighbor_index = (x_index * 16) + y_index;
                        if (q[neighbor_index]) begin
                            alive_neighbors = alive_neighbors + 1;
                        end
                    end
                end
            end
            case (alive_neighbors)
                0, 1, 4, 5, 6, 7, 8: next_q[i] = 0;
                3: next_q[i] = 1;
                default: next_q[i] = q[i];
            endcase
        end
        q <= next_q;
    end
end

endmodule