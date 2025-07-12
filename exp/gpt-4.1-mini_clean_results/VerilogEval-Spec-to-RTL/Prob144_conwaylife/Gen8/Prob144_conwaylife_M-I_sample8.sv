module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    localparam SIZE = 16;
    localparam MASK = 4'hF;

    // Use 2D register array to hold current state
    reg [SIZE-1:0] grid [SIZE-1:0];
    integer i, j;

    // Assign input q from flattened grid state for external visibility
    always @(*) begin
        for (i = 0; i < SIZE; i = i + 1)
            for (j = 0; j < SIZE; j = j + 1)
                q[i*SIZE + j] = grid[i][j];
    end

    // Compute neighbor count with balanced adder tree for each cell
    wire [3:0] neighbor_count [SIZE-1:0][SIZE-1:0];

    genvar r, c;

    generate
        for (r = 0; r < SIZE; r = r + 1) begin : ROW_LOOP
            for (c = 0; c < SIZE; c = c + 1) begin : COL_LOOP
                // Wrap indices for neighbors
                wire [3:0] r_up   = (r == 0)     ? MASK : r - 1;
                wire [3:0] r_down = (r == MASK)  ? 0    : r + 1;
                wire [3:0] c_left = (c == 0)     ? MASK : c - 1;
                wire [3:0] c_right= (c == MASK)  ? 0    : c + 1;

                // Neighbor bits
                wire n0 = grid[r_up][c_left];
                wire n1 = grid[r_up][c];
                wire n2 = grid[r_up][c_right];
                wire n3 = grid[r][c_left];
                wire n4 = grid[r][c_right];
                wire n5 = grid[r_down][c_left];
                wire n6 = grid[r_down][c];
                wire n7 = grid[r_down][c_right];

                // Balanced adder tree summation of neighbors
                wire [1:0] sum01 = n0 + n1;
                wire [1:0] sum23 = n2 + n3;
                wire [1:0] sum45 = n4 + n5;
                wire [1:0] sum67 = n6 + n7;

                wire [2:0] sum0123 = sum01 + sum23;
                wire [2:0] sum4567 = sum45 + sum67;

                wire [3:0] total_neighbors = sum0123 + sum4567;

                assign neighbor_count[r][c] = total_neighbors;
            end
        end
    endgenerate

    // Compute next grid state based on rules
    wire next_grid [SIZE-1:0][SIZE-1:0];
    generate
        for (r = 0; r < SIZE; r = r + 1) begin : NEXT_ROW
            for (c = 0; c < SIZE; c = c + 1) begin : NEXT_COL
                // Apply rules:
                // 0-1 neighbors -> 0
                // 2 neighbors -> current state
                // 3 neighbors -> 1
                // 4+ neighbors -> 0
                assign next_grid[r][c] = (neighbor_count[r][c] == 4'd3) ? 1'b1 :
                                         (neighbor_count[r][c] == 4'd2) ? grid[r][c] : 1'b0;
            end
        end
    endgenerate

    // Update grid register on clock edge
    always @(posedge clk) begin
        if (load) begin
            // Load initial state from input data
            for (i = 0; i < SIZE; i = i + 1)
                grid[i] <= data[i*SIZE +: SIZE];
        end else begin
            // Update state to next generation
            for (i = 0; i < SIZE; i = i + 1)
                for (j = 0; j < SIZE; j = j + 1)
                    grid[i][j] <= next_grid[i][j];
        end
    end

endmodule