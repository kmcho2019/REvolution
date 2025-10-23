module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;

// Combinational logic to count alive neighbours
reg [2:0] neighbours[15:0][15:0];
reg [15:0] row;
reg [15:0] col;

always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                neighbours[i][j] = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if ((x == 0) && (y == 0)) begin
                            continue;
                        end
                        int new_i = (i + x + 16) % 16;
                        int new_j = (j + y + 16) % 16;
                        if (grid[(new_i * 16) + new_j]) begin
                            neighbours[i][j] = neighbours[i][j] + 1;
                        end
                    end
                end
            end
        end
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                case (neighbours[i][j])
                    0, 1: grid[(i * 16) + j] <= 0;
                    2: grid[(i * 16) + j] <= grid[(i * 16) + j];
                    3: grid[(i * 16) + j] <= 1;
                    default: grid[(i * 16) + j] <= 0;
                endcase
            end
        end
    end
    q <= grid;
end

endmodule