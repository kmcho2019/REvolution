module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    integer i, j, x, y, row, col, count;
    reg [255:0] next_state;
    
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    count = 0;
                    // Count live neighbors with toroidal wrapping
                    for (x = -1; x <= 1; x = x + 1) begin
                        for (y = -1; y <= 1; y = y + 1) begin
                            if (x == 0 && y == 0) continue;
                            row = (i + x + 16) % 16;
                            col = (j + y + 16) % 16;
                            count = count + q[row * 16 + col];
                        end
                    end
                    // Apply game rules
                    next_state[i*16 + j] = (count == 3) || (count == 2 && q[i*16 + j]);
                end
            end
            q <= next_state;
        end
    end

endmodule