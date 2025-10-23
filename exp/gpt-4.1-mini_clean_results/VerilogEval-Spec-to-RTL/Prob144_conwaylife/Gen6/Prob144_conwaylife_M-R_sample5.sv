module TopModule(
    input               clk,
    input               load,
    input      [255:0]  data,
    output reg [255:0]  q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Represent grid as 2D array internally for clarity
    reg [0:0] grid [0:HEIGHT-1][0:WIDTH-1];
    reg [0:0] next_grid [0:HEIGHT-1][0:WIDTH-1];

    integer i, j;

    // On load or update q, also update internal grid representation
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            for (i = 0; i < HEIGHT; i = i + 1)
                for (j = 0; j < WIDTH; j = j + 1)
                    grid[i][j] <= data[(i*WIDTH)+j];
        end else begin
            q <= {next_grid[15][15], next_grid[15][14], next_grid[15][13], next_grid[15][12], next_grid[15][11], next_grid[15][10], next_grid[15][9], next_grid[15][8],
                  next_grid[15][7],  next_grid[15][6],  next_grid[15][5],  next_grid[15][4],  next_grid[15][3],  next_grid[15][2],  next_grid[15][1],  next_grid[15][0],
                  next_grid[14][15], next_grid[14][14], next_grid[14][13], next_grid[14][12], next_grid[14][11], next_grid[14][10], next_grid[14][9], next_grid[14][8],
                  next_grid[14][7],  next_grid[14][6],  next_grid[14][5],  next_grid[14][4],  next_grid[14][3],  next_grid[14][2],  next_grid[14][1],  next_grid[14][0],
                  next_grid[13][15], next_grid[13][14], next_grid[13][13], next_grid[13][12], next_grid[13][11], next_grid[13][10], next_grid[13][9], next_grid[13][8],
                  next_grid[13][7],  next_grid[13][6],  next_grid[13][5],  next_grid[13][4],  next_grid[13][3],  next_grid[13][2],  next_grid[13][1],  next_grid[13][0],
                  next_grid[12][15], next_grid[12][14], next_grid[12][13], next_grid[12][12], next_grid[12][11], next_grid[12][10], next_grid[12][9], next_grid[12][8],
                  next_grid[12][7],  next_grid[12][6],  next_grid[12][5],  next_grid[12][4],  next_grid[12][3],  next_grid[12][2],  next_grid[12][1],  next_grid[12][0],
                  next_grid[11][15], next_grid[11][14], next_grid[11][13], next_grid[11][12], next_grid[11][11], next_grid[11][10], next_grid[11][9], next_grid[11][8],
                  next_grid[11][7],  next_grid[11][6],  next_grid[11][5],  next_grid[11][4],  next_grid[11][3],  next_grid[11][2],  next_grid[11][1],  next_grid[11][0],
                  next_grid[10][15], next_grid[10][14], next_grid[10][13], next_grid[10][12], next_grid[10][11], next_grid[10][10], next_grid[10][9], next_grid[10][8],
                  next_grid[10][7],  next_grid[10][6],  next_grid[10][5],  next_grid[10][4],  next_grid[10][3],  next_grid[10][2],  next_grid[10][1],  next_grid[10][0],
                  next_grid[9][15],  next_grid[9][14],  next_grid[9][13],  next_grid[9][12],  next_grid[9][11],  next_grid[9][10],  next_grid[9][9],  next_grid[9][8],
                  next_grid[9][7],   next_grid[9][6],   next_grid[9][5],   next_grid[9][4],   next_grid[9][3],   next_grid[9][2],   next_grid[9][1],   next_grid[9][0],
                  next_grid[8][15],  next_grid[8][14],  next_grid[8][13],  next_grid[8][12],  next_grid[8][11],  next_grid[8][10],  next_grid[8][9],  next_grid[8][8],
                  next_grid[8][7],   next_grid[8][6],   next_grid[8][5],   next_grid[8][4],   next_grid[8][3],   next_grid[8][2],   next_grid[8][1],   next_grid[8][0],
                  next_grid[7][15],  next_grid[7][14],  next_grid[7][13],  next_grid[7][12],  next_grid[7][11],  next_grid[7][10],  next_grid[7][9],  next_grid[7][8],
                  next_grid[7][7],   next_grid[7][6],   next_grid[7][5],   next_grid[7][4],   next_grid[7][3],   next_grid[7][2],   next_grid[7][1],   next_grid[7][0],
                  next_grid[6][15],  next_grid[6][14],  next_grid[6][13],  next_grid[6][12],  next_grid[6][11],  next_grid[6][10],  next_grid[6][9],  next_grid[6][8],
                  next_grid[6][7],   next_grid[6][6],   next_grid[6][5],   next_grid[6][4],   next_grid[6][3],   next_grid[6][2],   next_grid[6][1],   next_grid[6][0],
                  next_grid[5][15],  next_grid[5][14],  next_grid[5][13],  next_grid[5][12],  next_grid[5][11],  next_grid[5][10],  next_grid[5][9],  next_grid[5][8],
                  next_grid[5][7],   next_grid[5][6],   next_grid[5][5],   next_grid[5][4],   next_grid[5][3],   next_grid[5][2],   next_grid[5][1],   next_grid[5][0],
                  next_grid[4][15],  next_grid[4][14],  next_grid[4][13],  next_grid[4][12],  next_grid[4][11],  next_grid[4][10],  next_grid[4][9],  next_grid[4][8],
                  next_grid[4][7],   next_grid[4][6],   next_grid[4][5],   next_grid[4][4],   next_grid[4][3],   next_grid[4][2],   next_grid[4][1],   next_grid[4][0],
                  next_grid[3][15],  next_grid[3][14],  next_grid[3][13],  next_grid[3][12],  next_grid[3][11],  next_grid[3][10],  next_grid[3][9],  next_grid[3][8],
                  next_grid[3][7],   next_grid[3][6],   next_grid[3][5],   next_grid[3][4],   next_grid[3][3],   next_grid[3][2],   next_grid[3][1],   next_grid[3][0],
                  next_grid[2][15],  next_grid[2][14],  next_grid[2][13],  next_grid[2][12],  next_grid[2][11],  next_grid[2][10],  next_grid[2][9],  next_grid[2][8],
                  next_grid[2][7],   next_grid[2][6],   next_grid[2][5],   next_grid[2][4],   next_grid[2][3],   next_grid[2][2],   next_grid[2][1],   next_grid[2][0],
                  next_grid[1][15],  next_grid[1][14],  next_grid[1][13],  next_grid[1][12],  next_grid[1][11],  next_grid[1][10],  next_grid[1][9],  next_grid[1][8],
                  next_grid[1][7],   next_grid[1][6],   next_grid[1][5],   next_grid[1][4],   next_grid[1][3],   next_grid[1][2],   next_grid[1][1],   next_grid[1][0],
                  next_grid[0][15],  next_grid[0][14],  next_grid[0][13],  next_grid[0][12],  next_grid[0][11],  next_grid[0][10],  next_grid[0][9],  next_grid[0][8],
                  next_grid[0][7],   next_grid[0][6],   next_grid[0][5],   next_grid[0][4],   next_grid[0][3],   next_grid[0][2],   next_grid[0][1],   next_grid[0][0]};
            for (i = 0; i < HEIGHT; i = i + 1)
                for (j = 0; j < WIDTH; j = j + 1)
                    grid[i][j] <= next_grid[i][j];
        end
    end

    // Function to wrap index modulo 16 using masking
    function [3:0] wrap4;
        input integer idx;
        begin
            wrap4 = idx[3:0];  // automatically modulo 16 by truncation
        end
    endfunction

    // Function to compute next cell state based on neighbors and current state
    function cell_next_state;
        input [3:0] neighbor_count;
        input       current_state;
        begin
            case (neighbor_count)
                4'd0, 4'd1: cell_next_state = 1'b0;
                4'd2:       cell_next_state = current_state;
                4'd3:       cell_next_state = 1'b1;
                default:    cell_next_state = 1'b0; // 4 or more neighbors
            endcase
        end
    endfunction

    // Generate combinational logic for next_grid
    // Use continuous assignment within a generate-for structure
    genvar rr, cc;
    generate
        for (rr = 0; rr < HEIGHT; rr = rr + 1) begin : row_loop
            for (cc = 0; cc < WIDTH; cc = cc + 1) begin : col_loop
                wire [3:0] neighbor_cnt;
                wire [7:0] neighbors_vec;

                // Collect 8 neighbors with wrap-around indices
                assign neighbors_vec[0] = grid[wrap4(rr-1)][wrap4(cc-1)];
                assign neighbors_vec[1] = grid[wrap4(rr-1)][wrap4(cc)];
                assign neighbors_vec[2] = grid[wrap4(rr-1)][wrap4(cc+1)];
                assign neighbors_vec[3] = grid[wrap4(rr)][wrap4(cc-1)];
                assign neighbors_vec[4] = grid[wrap4(rr)][wrap4(cc+1)];
                assign neighbors_vec[5] = grid[wrap4(rr+1)][wrap4(cc-1)];
                assign neighbors_vec[6] = grid[wrap4(rr+1)][wrap4(cc)];
                assign neighbors_vec[7] = grid[wrap4(rr+1)][wrap4(cc+1)];

                // Sum neighbors using reduction
                assign neighbor_cnt = neighbors_vec[0] + neighbors_vec[1] + neighbors_vec[2] +
                                      neighbors_vec[3] + neighbors_vec[4] + neighbors_vec[5] +
                                      neighbors_vec[6] + neighbors_vec[7];

                always @(*) begin
                    next_grid[rr][cc] = cell_next_state(neighbor_cnt, grid[rr][cc]);
                end
            end
        end
    endgenerate

endmodule