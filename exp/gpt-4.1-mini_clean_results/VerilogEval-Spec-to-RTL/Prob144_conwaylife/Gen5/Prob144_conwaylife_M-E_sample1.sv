module TopModule (
    input           clk,
    input           load,
    input  [255:0]  data,
    output reg [255:0] q
);

    localparam WIDTH  = 16;
    localparam HEIGHT = 16;

    // Counters for current cell position
    reg [3:0] row;
    reg [3:0] col;

    // Registers for current state and next state computation
    reg [255:0] current_state;
    reg [255:0] next_state;

    // Combinational variables for neighbor count
    integer dr, dc;
    reg [3:0] neighbors;
    integer nr, nc;
    wire current_cell;

    // Compute index helper
    function integer idx(input [3:0] r, input [3:0] c);
        idx = (r << 4) + c;
    endfunction

    // Current cell state
    assign current_cell = current_state[idx(row, col)];

    // Count neighbors combinationally for current cell
    always @(*) begin
        neighbors = 0;
        for (dr = -1; dr <= 1; dr = dr + 1) begin
            for (dc = -1; dc <= 1; dc = dc + 1) begin
                if (!(dr == 0 && dc == 0)) begin
                    // Wrap-around toroidal indexing using 4-bit masking
                    nr = (row + dr) & 4'hF;
                    nc = (col + dc) & 4'hF;
                    neighbors = neighbors + current_state[idx(nr, nc)];
                end
            end
        end
    end

    // Sequential logic to update the state cell by cell
    always @(posedge clk) begin
        if (load) begin
            // Load initial data and reset position counters
            current_state <= data;
            next_state <= data;
            row <= 0;
            col <= 0;
            q <= data;
        end else begin
            // Compute next state for the current cell and store in next_state
            case (neighbors)
                2: next_state[idx(row, col)] <= current_cell; // state unchanged
                3: next_state[idx(row, col)] <= 1'b1;        // cell becomes alive
                default: next_state[idx(row, col)] <= 1'b0;  // else dead
            endcase

            // Move to next cell
            if (col == WIDTH - 1) begin
                col <= 0;
                if (row == HEIGHT - 1) begin
                    row <= 0;
                    // Finished one full iteration over the grid:
                    // commit next_state to current_state and output
                    current_state <= next_state;
                    q <= next_state;
                end else begin
                    row <= row + 1;
                end
            end else begin
                col <= col + 1;
            end
        end
    end

endmodule