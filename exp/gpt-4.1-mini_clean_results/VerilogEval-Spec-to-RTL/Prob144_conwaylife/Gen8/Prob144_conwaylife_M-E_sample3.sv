module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    localparam SIZE = 16;

    // Represent the grid as 2D reg array for state storage
    reg grid [0:SIZE-1][0:SIZE-1];
    reg next_grid [0:SIZE-1][0:SIZE-1];

    integer i, j;

    // Function to get cell value with toroidal wrap-around indexing
    function automatic bit get_cell(input integer row, input integer col);
        integer r_wrapped, c_wrapped;
        begin
            r_wrapped = (row < 0) ? row + SIZE : (row >= SIZE) ? row - SIZE : row;
            c_wrapped = (col < 0) ? col + SIZE : (col >= SIZE) ? col - SIZE : col;
            get_cell = grid[r_wrapped][c_wrapped];
        end
    endfunction

    // Compute next state in combinational block using neighbor counting function
    always @(*) begin
        for (i = 0; i < SIZE; i = i + 1) begin
            for (j = 0; j < SIZE; j = j + 1) begin
                integer neighbors;
                neighbors = 0;
                // Sum all 8 neighbors using get_cell
                neighbors = get_cell(i-1, j-1) + get_cell(i-1, j) + get_cell(i-1, j+1) +
                            get_cell(i,   j-1)                 + get_cell(i,   j+1) +
                            get_cell(i+1, j-1) + get_cell(i+1, j) + get_cell(i+1, j+1);

                // Apply rules
                if (neighbors <= 1) begin
                    next_grid[i][j] = 1'b0;
                end else if (neighbors == 2) begin
                    next_grid[i][j] = grid[i][j];
                end else if (neighbors == 3) begin
                    next_grid[i][j] = 1'b1;
                end else begin
                    next_grid[i][j] = 1'b0;
                end
            end
        end
    end

    // Load input data into grid or update with computed next state at clock edge
    always @(posedge clk) begin
        if (load) begin
            // Load input vector 'data' into grid 2D array
            for (i = 0; i < SIZE; i = i + 1) begin
                for (j = 0; j < SIZE; j = j + 1) begin
                    grid[i][j] <= data[i*SIZE + j];
                end
            end
        end else begin
            // Update grid with next state
            for (i = 0; i < SIZE; i = i + 1) begin
                for (j = 0; j < SIZE; j = j + 1) begin
                    grid[i][j] <= next_grid[i][j];
                end
            end
        end
    end

    // Flatten grid 2D array into output vector q combinationally
    always @(*) begin
        for (i = 0; i < SIZE; i = i + 1) begin
            for (j = 0; j < SIZE; j = j + 1) begin
                q[i*SIZE + j] = grid[i][j];
            end
        end
    end

endmodule