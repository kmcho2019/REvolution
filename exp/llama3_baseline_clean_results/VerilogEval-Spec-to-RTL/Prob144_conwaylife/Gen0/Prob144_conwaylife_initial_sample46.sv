module TopModule(
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [2:0] neighbors;
                neighbors = 0;
                
                // Calculate the positions of the neighbors
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) begin
                            // Skip the current cell
                            continue;
                        end else begin
                            reg [7:0] neighbor_x;
                            reg [7:0] neighbor_y;
                            neighbor_x = (i + x + 16) % 16;
                            neighbor_y = (j + y + 16) % 16;
                            if (q_reg[neighbor_x*16 + neighbor_y]) begin
                                neighbors <= neighbors + 1;
                            end
                        end
                    end
                end
                
                // Update the state of the cell
                case (neighbors)
                    0, 1: q_reg[i*16 + j] <= 0;
                    2: q_reg[i*16 + j] <= q_reg[i*16 + j];
                    3: q_reg[i*16 + j] <= 1;
                    default: q_reg[i*16 + j] <= 0;
                endcase
            end
        end
    end
end

assign q = q_reg;

endmodule