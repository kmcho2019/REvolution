module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

// Instantiate 16 SubGridModules, one for each 4x4 sub-grid
wire [15:0] sub_grid_0_out;
wire [15:0] sub_grid_1_out;
wire [15:0] sub_grid_2_out;
wire [15:0] sub_grid_3_out;
wire [15:0] sub_grid_4_out;
wire [15:0] sub_grid_5_out;
wire [15:0] sub_grid_6_out;
wire [15:0] sub_grid_7_out;
wire [15:0] sub_grid_8_out;
wire [15:0] sub_grid_9_out;
wire [15:0] sub_grid_10_out;
wire [15:0] sub_grid_11_out;
wire [15:0] sub_grid_12_out;
wire [15:0] sub_grid_13_out;
wire [15:0] sub_grid_14_out;
wire [15:0] sub_grid_15_out;

SubGridModule sub_grid_0(
   .q(q[15:0]),
   .north(q[31:16]),
   .south(q[47:32]),
   .east(q[15:0]),
   .west(q[15:0]),
   .next_q(sub_grid_0_out)
);

SubGridModule sub_grid_1(
   .q(q[31:16]),
   .north(q[15:0]),
   .south(q[63:48]),
   .east(q[31:16]),
   .west(q[15:0]),
   .next_q(sub_grid_1_out)
);

SubGridModule sub_grid_2(
   .q(q[47:32]),
   .north(q[63:48]),
   .south(q[95:80]),
   .east(q[47:32]),
   .west(q[31:16]),
   .next_q(sub_grid_2_out)
);

SubGridModule sub_grid_3(
   .q(q[63:48]),
   .north(q[95:80]),
   .south(q[127:112]),
   .east(q[63:48]),
   .west(q[47:32]),
   .next_q(sub_grid_3_out)
);

SubGridModule sub_grid_4(
   .q(q[79:64]),
   .north(q[111:96]),
   .south(q[143:128]),
   .east(q[79:64]),
   .west(q[63:48]),
   .next_q(sub_grid_4_out)
);

SubGridModule sub_grid_5(
   .q(q[95:80]),
   .north(q[127:112]),
   .south(q[159:144]),
   .east(q[95:80]),
   .west(q[79:64]),
   .next_q(sub_grid_5_out)
);

SubGridModule sub_grid_6(
   .q(q[111:96]),
   .north(q[143:128]),
   .south(q[175:160]),
   .east(q[111:96]),
   .west(q[95:80]),
   .next_q(sub_grid_6_out)
);

SubGridModule sub_grid_7(
   .q(q[127:112]),
   .north(q[159:144]),
   .south(q[191:176]),
   .east(q[127:112]),
   .west(q[111:96]),
   .next_q(sub_grid_7_out)
);

SubGridModule sub_grid_8(
   .q(q[143:128]),
   .north(q[175:160]),
   .south(q[207:192]),
   .east(q[143:128]),
   .west(q[127:112]),
   .next_q(sub_grid_8_out)
);

SubGridModule sub_grid_9(
   .q(q[159:144]),
   .north(q[191:176]),
   .south(q[223:208]),
   .east(q[159:144]),
   .west(q[143:128]),
   .next_q(sub_grid_9_out)
);

SubGridModule sub_grid_10(
   .q(q[175:160]),
   .north(q[207:192]),
   .south(q[239:224]),
   .east(q[175:160]),
   .west(q[159:144]),
   .next_q(sub_grid_10_out)
);

SubGridModule sub_grid_11(
   .q(q[191:176]),
   .north(q[223:208]),
   .south(q[255:240]),
   .east(q[191:176]),
   .west(q[175:160]),
   .next_q(sub_grid_11_out)
);

SubGridModule sub_grid_12(
   .q(q[207:192]),
   .north(q[239:224]),
   .south(q[15:0]),
   .east(q[207:192]),
   .west(q[191:176]),
   .next_q(sub_grid_12_out)
);

SubGridModule sub_grid_13(
   .q(q[223:208]),
   .north(q[255:240]),
   .south(q[31:16]),
   .east(q[223:208]),
   .west(q[207:192]),
   .next_q(sub_grid_13_out)
);

SubGridModule sub_grid_14(
   .q(q[239:224]),
   .north(q[15:0]),
   .south(q[47:32]),
   .east(q[239:224]),
   .west(q[223:208]),
   .next_q(sub_grid_14_out)
);

SubGridModule sub_grid_15(
   .q(q[255:240]),
   .north(q[31:16]),
   .south(q[63:48]),
   .east(q[255:240]),
   .west(q[239:224]),
   .next_q(sub_grid_15_out)
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        next_q[15:0] <= sub_grid_0_out;
        next_q[31:16] <= sub_grid_1_out;
        next_q[47:32] <= sub_grid_2_out;
        next_q[63:48] <= sub_grid_3_out;
        next_q[79:64] <= sub_grid_4_out;
        next_q[95:80] <= sub_grid_5_out;
        next_q[111:96] <= sub_grid_6_out;
        next_q[127:112] <= sub_grid_7_out;
        next_q[143:128] <= sub_grid_8_out;
        next_q[159:144] <= sub_grid_9_out;
        next_q[175:160] <= sub_grid_10_out;
        next_q[191:176] <= sub_grid_11_out;
        next_q[207:192] <= sub_grid_12_out;
        next_q[223:208] <= sub_grid_13_out;
        next_q[239:224] <= sub_grid_14_out;
        next_q[255:240] <= sub_grid_15_out;
        q <= next_q;
    end
end

endmodule

module SubGridModule(
    input [15:0] q,
    input [15:0] north,
    input [15:0] south,
    input [15:0] east,
    input [15:0] west,
    output [15:0] next_q
);

reg [15:0] alive_neighbors;
reg [15:0] next_q_temp;

always @(q or north or south or east or west) begin
    next_q_temp = 16'b0;
    for (int i = 0; i < 16; i = i + 1) begin
        alive_neighbors = 0;
        for (int x = -1; x <= 1; x = x + 1) begin
            for (int y = -1; y <= 1; y = y + 1) begin
                if (x == 0 && y == 0) begin
                    continue;
                end
                reg [3:0] neighbor_x = (i / 4 + x + 4) % 4;
                reg [3:0] neighbor_y = (i % 4 + y + 4) % 4;
                reg [3:0] neighbor_index = neighbor_x * 4 + neighbor_y;
                if (neighbor_x == 0) begin
                    if (neighbor_y == 0) begin
                        alive_neighbors = alive_neighbors + west[neighbor_index];
                    end else if (neighbor_y == 1) begin
                        alive_neighbors = alive_neighbors + west[neighbor_index];
                    end else if (neighbor_y == 2) begin
                        alive_neighbors = alive_neighbors + west[neighbor_index];
                    end else if (neighbor_y == 3) begin
                        alive_neighbors = alive_neighbors + west[neighbor_index];
                    end
                end else if (neighbor_x == 1) begin
                    if (neighbor_y == 0) begin
                        alive_neighbors = alive_neighbors + q[neighbor_index];
                    end else if (neighbor_y == 1) begin
                        alive_neighbors = alive_neighbors + q[neighbor_index];
                    end else if (neighbor_y == 2) begin
                        alive_neighbors = alive_neighbors + q[neighbor_index];
                    end else if (neighbor_y == 3) begin
                        alive_neighbors = alive_neighbors + q[neighbor_index];
                    end
                end else if (neighbor_x == 2) begin
                    if (neighbor_y == 0) begin
                        alive_neighbors = alive_neighbors + south[neighbor_index];
                    end else if (neighbor_y == 1) begin
                        alive_neighbors = alive_neighbors + south[neighbor_index];
                    end else if (neighbor_y == 2) begin
                        alive_neighbors = alive_neighbors + south[neighbor_index];
                    end else if (neighbor_y == 3) begin
                        alive_neighbors = alive_neighbors + south[neighbor_index];
                    end
                end else if (neighbor_x == 3) begin
                    if (neighbor_y == 0) begin
                        alive_neighbors = alive_neighbors + east[neighbor_index];
                    end else if (neighbor_y == 1) begin
                        alive_neighbors = alive_neighbors + east[neighbor_index];
                    end else if (neighbor_y == 2) begin
                        alive_neighbors = alive_neighbors + east[neighbor_index];
                    end else if (neighbor_y == 3) begin
                        alive_neighbors = alive_neighbors + east[neighbor_index];
                    end
                end
            end
        end
        if (alive_neighbors < 2 || alive_neighbors > 3) begin
            next_q_temp[i] = 0;
        end else if (alive_neighbors == 3) begin
            next_q_temp[i] = 1;
        end else begin
            next_q_temp[i] = q[i];
        end
    end
    next_q = next_q_temp;
end

endmodule