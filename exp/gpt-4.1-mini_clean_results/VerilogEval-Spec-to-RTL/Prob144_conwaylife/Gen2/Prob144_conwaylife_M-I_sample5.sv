module TopModule (
    input           clk,
    input           load,
    input  [255:0]  data,
    output reg [255:0] q
);

    // Grid dimensions
    localparam WIDTH  = 16;
    localparam HEIGHT = 16;

    // State machine states
    localparam IDLE  = 1'b0;
    localparam RUN   = 1'b1;

    reg state;
    reg [3:0] row_idx; // 0..15 current row being computed

    integer c, dr, dc;
    integer nr, nc;
    integer neighbors;
    reg current_cell;

    reg [255:0] next_q;        // Holds next generation grid
    reg [15:0] next_row;       // Holds computed next state for current row

    // Combinational logic: compute next_row for row_idx
    always @(*) begin
        next_row = 16'b0;
        for (c = 0; c < WIDTH; c = c + 1) begin
            neighbors = 0;
            for (dr = -1; dr <= 1; dr = dr + 1) begin
                for (dc = -1; dc <= 1; dc = dc + 1) begin
                    if (!(dr == 0 && dc == 0)) begin
                        // Wrap neighbors using bit masking for toroidal wrap
                        nr = (row_idx + dr) & 4'hF;
                        nc = (c + dc) & 4'hF;
                        neighbors = neighbors + q[(nr << 4) + nc];
                    end
                end
            end
            current_cell = q[(row_idx << 4) + c];
            // Apply Game of Life rules:
            // 0-1 neighbor: 0; 2 neighbors: keep; 3 neighbors: 1; 4+ neighbors: 0
            if (neighbors <= 1)
                next_row[c] = 1'b0;
            else if (neighbors == 2)
                next_row[c] = current_cell;
            else if (neighbors == 3)
                next_row[c] = 1'b1;
            else
                next_row[c] = 1'b0;
        end
    end

    // Sequential logic: control state machine and update next_q and q
    always @(posedge clk) begin
        if (load) begin
            // Load initial state immediately
            q <= data;
            next_q <= data;
            row_idx <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    // Start computing next generation row by row
                    row_idx <= 0;
                    state <= RUN;
                end
                RUN: begin
                    // Update next_q with the computed next_row for current row
                    next_q[(row_idx << 4) +: 16] <= next_row;
                    if (row_idx == HEIGHT - 1) begin
                        // Finished all rows, update q and go back to IDLE
                        q <= next_q;
                        state <= IDLE;
                    end else begin
                        row_idx <= row_idx + 1;
                    end
                end
            endcase
        end
    end

endmodule