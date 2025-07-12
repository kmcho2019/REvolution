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
    next_q = q;
    for (int y = 0; y < 16; y++) begin
        for (int x = 0; x < 16; x++) begin
            reg [2:0] neighbors;
            // Count neighbors
            neighbors = 0;
            for (int dy = -1; dy <= 1; dy++) begin
                for (int dx = -1; dx <= 1; dx++) begin
                    if (dx == 0 && dy == 0) continue; // Skip the cell itself
                    reg [7:0] x_wrap, y_wrap;
                    x_wrap = (x + dx + 16) % 16;
                    y_wrap = (y + dy + 16) % 16;
                    if (q[(y_wrap * 16) + x_wrap]) neighbors <= neighbors + 1;
                end
            end
            // Apply game rules
            if (neighbors <= 1) begin
                next_q[(y * 16) + x] = 0;
            end else if (neighbors == 2) begin
                // No change
            end else if (neighbors == 3) begin
                next_q[(y * 16) + x] = 1;
            end else begin
                next_q[(y * 16) + x] = 0;
            end
        end
    end
end

endmodule