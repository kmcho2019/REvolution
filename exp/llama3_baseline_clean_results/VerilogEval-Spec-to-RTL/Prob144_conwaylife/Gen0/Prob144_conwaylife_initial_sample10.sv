module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    next_state = 256'd0;
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            reg [2:0] neighbor_count;
            neighbor_count = 3'd0;

            // Calculate neighbor count
            for (integer x = -1; x <= 1; x = x + 1) begin
                for (integer y = -1; y <= 1; y = y + 1) begin
                    if (x == 0 && y == 0) begin
                        continue;
                    end

                    integer row, col;
                    row = (i + x + 16) % 16;
                    col = (j + y + 16) % 16;

                    if (current_state[row * 16 + col]) begin
                        neighbor_count = neighbor_count + 1'd1;
                    end
                end
            end

            // Apply game rules
            if (neighbor_count <= 1 || neighbor_count >= 4) begin
                next_state[i * 16 + j] = 1'd0;
            end else if (neighbor_count == 2) begin
                next_state[i * 16 + j] = current_state[i * 16 + j];
            end else if (neighbor_count == 3) begin
                next_state[i * 16 + j] = 1'd1;
            end
        end
    end
end

assign q = current_state;

endmodule