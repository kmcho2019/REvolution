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
            q <= next_q;
        end
    end

    always @(*) begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [3:0] alive_neighbors;
                alive_neighbors = 0;

                // Count alive neighbors
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) continue;

                        reg [7:0] x_idx, y_idx;
                        x_idx = (i + x + 16) % 16;
                        y_idx = (j + y + 16) % 16;

                        if (q[x_idx * 16 + y_idx]) begin
                            alive_neighbors <= alive_neighbors + 1;
                        end
                    end
                end

                // Update cell state
                case (alive_neighbors)
                    4'b0000, 4'b0001: next_q[i * 16 + j] <= 1'b0;
                    4'b0010: next_q[i * 16 + j] <= q[i * 16 + j];
                    4'b0011: next_q[i * 16 + j] <= 1'b1;
                    default: next_q[i * 16 + j] <= 1'b0;
                endcase
            end
        end
    end

endmodule