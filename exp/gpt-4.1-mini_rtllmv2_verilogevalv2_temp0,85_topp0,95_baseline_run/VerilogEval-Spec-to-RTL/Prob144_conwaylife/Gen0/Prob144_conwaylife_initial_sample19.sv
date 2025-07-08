module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // parameters for grid size
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    integer r, c;
    reg [3:0] neighbor_count;
    reg current_cell;
    reg [255:0] next_state;

    // function to wrap index (modular arithmetic for toroid)
    function [3:0] wrap_idx;
        input integer idx;
        begin
            if (idx < 0)
                wrap_idx = idx + WIDTH;
            else if (idx >= WIDTH)
                wrap_idx = idx - WIDTH;
            else
                wrap_idx = idx[3:0];
        end
    endfunction

    // Get cell state at (row,col)
    function get_cell;
        input integer row;
        input integer col;
        begin
            get_cell = q[wrap_idx(row)*WIDTH + wrap_idx(col)];
        end
    endfunction

    always @(*) begin
        // Compute next state combinationally
        next_state = 256'b0;
        for (r = 0; r < HEIGHT; r = r + 1) begin
            for (c = 0; c < WIDTH; c = c + 1) begin
                // Count neighbors
                neighbor_count = 0;
                neighbor_count = neighbor_count + get_cell(r-1, c-1);
                neighbor_count = neighbor_count + get_cell(r-1, c);
                neighbor_count = neighbor_count + get_cell(r-1, c+1);
                neighbor_count = neighbor_count + get_cell(r,   c-1);
                neighbor_count = neighbor_count + get_cell(r,   c+1);
                neighbor_count = neighbor_count + get_cell(r+1, c-1);
                neighbor_count = neighbor_count + get_cell(r+1, c);
                neighbor_count = neighbor_count + get_cell(r+1, c+1);

                current_cell = get_cell(r, c);

                // Apply rules
                if (neighbor_count <= 1)
                    next_state[r*WIDTH + c] = 1'b0;
                else if (neighbor_count == 2)
                    next_state[r*WIDTH + c] = current_cell;
                else if (neighbor_count == 3)
                    next_state[r*WIDTH + c] = 1'b1;
                else // neighbor_count >= 4
                    next_state[r*WIDTH + c] = 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule