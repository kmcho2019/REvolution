module TopModule(
    input               clk,
    input               load,
    input      [255:0]  data,
    output reg [255:0]  q
);

    reg [255:0] next_q;

    integer i, j, x, y, alive_neighbors;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (i = 0; i < 256; i = i + 1) begin
                x = i % 16;
                y = i / 16;

                alive_neighbors = 0;
                for (j = -1; j <= 1; j = j + 1) begin
                    for (integer k = -1; k <= 1; k = k + 1) begin
                        if ((j != 0 || k != 0) && q[((((y + j) % 16) * 16) + ((x + k) % 16))] == 1'b1) begin
                            alive_neighbors = alive_neighbors + 1;
                        end
                    end
                end

                if (alive_neighbors < 2 || alive_neighbors > 3) begin
                    next_q[i] = 1'b0;
                end else if (alive_neighbors == 3) begin
                    next_q[i] = 1'b1;
                end else begin
                    next_q[i] = q[i];
                end
            end
            q <= next_q;
        end
    end

endmodule