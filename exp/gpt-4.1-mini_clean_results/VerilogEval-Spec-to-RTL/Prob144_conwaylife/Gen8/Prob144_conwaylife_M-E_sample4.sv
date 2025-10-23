module TopModule (
    input              clk,
    input              load,
    input      [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    reg [255:0] state;       // current full grid state
    reg [3:0]   row_idx;     // row being updated (0-15)

    integer c, dr, dc;
    integer nr, nc;
    integer neighbors;
    reg current_cell;
    reg [15:0] next_row;     // next state for row_idx

    // Wrap index modulo 16 with bitmask
    function [3:0] wrap16(input integer idx);
        begin
            wrap16 = idx & 4'hF;
        end
    endfunction

    // Compute next row state combinationally from current state and row_idx
    always @(*) begin
        for (c = 0; c < WIDTH; c = c + 1) begin
            neighbors = 0;
            for (dr = -1; dr <= 1; dr = dr + 1) begin
                nr = wrap16(row_idx + dr);
                for (dc = -1; dc <= 1; dc = dc + 1) begin
                    if (!(dr == 0 && dc == 0)) begin
                        nc = wrap16(c + dc);
                        neighbors = neighbors + state[(nr << 4) + nc];
                    end
                end
            end
            current_cell = state[(row_idx << 4) + c];
            if (neighbors <= 1)
                next_row[c] = 1'b0;
            else if (neighbors == 2)
                next_row[c] = current_cell;
            else if (neighbors == 3)
                next_row[c] = 1'b1;
            else // neighbors >= 4
                next_row[c] = 1'b0;
        end
    end

    // Sequential logic: load or update one row per clock
    always @(posedge clk) begin
        if (load) begin
            state <= data;
            row_idx <= 4'd0;
        end else begin
            // Update only row_idx row with next_row computed
            state[(row_idx << 4) +: WIDTH] <= next_row;
            row_idx <= wrap16(row_idx + 1);
        end
        q <= state; // output current full state every clock
    end

endmodule