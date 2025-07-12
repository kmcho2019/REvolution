module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] neighbor_count;
    reg [255:0] next_q;
    reg [255:0] neighbor_coords [0:7]; // Stores neighbor positions for all cells
    
    // Precompute neighbor coordinates for all cells
    always @(*) begin
        for (integer i = 0; i < 16; i = i + 1) begin
            for (integer j = 0; j < 16; j = j + 1) begin
                // Calculate neighbor coordinates with wrap-around using modulo
                neighbor_coords[0][i*16 + j] = ((i + 15) % 16) * 16 + ((j + 15) % 16); // NW
                neighbor_coords[1][i*16 + j] = ((i + 15) % 16) * 16 + j;               // N
                neighbor_coords[2][i*16 + j] = ((i + 15) % 16) * 16 + ((j + 1) % 16);   // NE
                neighbor_coords[3][i*16 + j] = i * 16 + ((j + 15) % 16);               // W
                neighbor_coords[4][i*16 + j] = i * 16 + ((j + 1) % 16);                // E
                neighbor_coords[5][i*16 + j] = ((i + 1) % 16) * 16 + ((j + 15) % 16);   // SW
                neighbor_coords[6][i*16 + j] = ((i + 1) % 16) * 16 + j;                // S
                neighbor_coords[7][i*16 + j] = ((i + 1) % 16) * 16 + ((j + 1) % 16);    // SE
            end
        end
    end

    // Calculate neighbor counts
    always @(*) begin
        for (integer i = 0; i < 256; i = i + 1) begin
            neighbor_count[i] = q[neighbor_coords[0][i]] + q[neighbor_coords[1][i]] +
                               q[neighbor_coords[2][i]] + q[neighbor_coords[3][i]] +
                               q[neighbor_coords[4][i]] + q[neighbor_coords[5][i]] +
                               q[neighbor_coords[6][i]] + q[neighbor_coords[7][i]];
        end
    end

    // Calculate next state with clock gating for stable cells
    always @(*) begin
        for (integer i = 0; i < 256; i = i + 1) begin
            if (neighbor_count[i] == 2) begin
                next_q[i] = q[i]; // No change - will be clock gated
            end else begin
                next_q[i] = (neighbor_count[i] == 3) ? 1'b1 : 1'b0;
            end
        end
    end

    // Update state with clock gating for stable cells
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer i = 0; i < 256; i = i + 1) begin
                if (neighbor_count[i] != 2) begin // Only update changing cells
                    q[i] <= next_q[i];
                end
            end
        end
    end

endmodule