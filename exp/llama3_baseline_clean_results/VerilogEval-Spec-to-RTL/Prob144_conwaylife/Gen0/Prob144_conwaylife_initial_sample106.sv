module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] temp_q;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [2:0] neighbours;
                neighbours = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if ((x == 0) && (y == 0)) begin
                            // Don't count the cell itself
                        end else begin
                            reg [4:0] row, col;
                            row = (i + x + 16) % 16;
                            col = (j + y + 16) % 16;
                            if (q[row*16 + col]) begin
                                neighbours <= neighbours + 1;
                            end
                        end
                    end
                end
                if ((neighbours < 2) || (neighbours > 3)) begin
                    temp_q[i*16 + j] <= 0;
                end else if (neighbours == 3) begin
                    temp_q[i*16 + j] <= 1;
                end else begin
                    temp_q[i*16 + j] <= q[i*16 + j];
                end
            end
        end
        q <= temp_q;
    end
end

endmodule