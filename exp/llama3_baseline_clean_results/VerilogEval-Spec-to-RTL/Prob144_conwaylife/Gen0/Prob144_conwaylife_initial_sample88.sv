module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_state;

integer i, j;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_state;
    end
end

always @(*) begin
    next_state = 0;
    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            reg [7:0] neighbors;
            reg cell;

            // Count the number of alive neighbors
            cell = q[i*16 + j];
            neighbors[0] = q[((i-1+16)%16)*16 + ((j-1+16)%16)];
            neighbors[1] = q[((i-1+16)%16)*16 + j];
            neighbors[2] = q[((i-1+16)%16)*16 + ((j+1)%16)];
            neighbors[3] = q[i*16 + ((j-1+16)%16)];
            neighbors[4] = q[i*16 + ((j+1)%16)];
            neighbors[5] = q[((i+1)%16)*16 + ((j-1+16)%16)];
            neighbors[6] = q[((i+1)%16)*16 + j];
            neighbors[7] = q[((i+1)%16)*16 + ((j+1)%16)];

            // Determine the next state of the cell based on the game rules
            if (cell == 1'b0 && |neighbors == 3) begin
                next_state[i*16 + j] = 1'b1;
            end else if (cell == 1'b1 && (|neighbors == 2 || |neighbors == 3)) begin
                next_state[i*16 + j] = 1'b1;
            end else begin
                next_state[i*16 + j] = 1'b0;
            end
        end
    end
end

endmodule